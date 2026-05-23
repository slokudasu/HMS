package com.hms.restaurent.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.hms.dto.Table;
import com.hms.entity.restaurent.Hall;
import com.hms.entity.restaurent.RestaurantUser;
import com.hms.entity.restaurent.RestaurantTable;
import com.hms.restaurent.dto.HallDTO;
import com.hms.restaurent.mapper.HallMapper;
import com.hms.restaurent.repository.HallRepository;
import com.hms.restaurent.repository.RestaurantUserRepository;
import com.hms.restaurent.repository.TableRepository;

@Service
public class HallService {

    @Autowired
    private HallRepository repository;
    
    @Autowired
    private TableRepository tableRepository;

    @Autowired
    private RestaurantUserRepository restaurantUserRepository;

    public HallDTO save(HallDTO dto, Long restaurantUserId) {
        String name = normalizeName(dto.getName());
        String status = normalizeStatus(dto.getStatus());
        RestaurantUser restaurantUser = findRestaurantUser(restaurantUserId);

        if (repository.existsByRestaurantUser_IdAndNameIgnoreCase(restaurantUserId, name)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Room / Hall already exists");
        }

        Hall entity = HallMapper.toEntity(dto);
        entity.setId(null);
        entity.setName(name);
        entity.setStatus(status);
        entity.setRestaurantUser(restaurantUser);

        Hall saved = repository.save(entity);
        return HallMapper.toDto(saved);
    }

    public List<HallDTO> findAll(Long restaurantUserId) {
        return repository.findByRestaurantUser_Id(restaurantUserId)
                .stream()
                .map(hall -> toHallDto(hall, false))
                .toList();
    }

    public HallDTO findById(Long id, Long restaurantUserId) {
        Hall entity = repository.findByIdAndRestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Room / Hall not found"));

        return toHallDto(entity, false);
    }

    public HallDTO update(Long id, HallDTO dto, Long restaurantUserId) {
        String name = normalizeName(dto.getName());
        String status = normalizeStatus(dto.getStatus());

        Hall entity = repository.findByIdAndRestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Room / Hall not found"));

        if (repository.existsByRestaurantUser_IdAndNameIgnoreCaseAndIdNot(restaurantUserId, name, id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Room / Hall already exists");
        }

        HallMapper.updateEntity(entity, dto);
        entity.setName(name);
        entity.setStatus(status);

        Hall updated = repository.save(entity);

        return HallMapper.toDto(updated);
    }

    public void delete(Long id, Long restaurantUserId) {
        Hall entity = repository.findByIdAndRestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Room / Hall not found"));
        repository.delete(entity);
    }

    public List<HallDTO> findActive(Long restaurantUserId) {
        return repository.findByRestaurantUser_IdAndStatus(restaurantUserId, "ACTIVE")
                .stream()
                .map(hall -> toHallDto(hall, true))
                .toList();
    }

    private HallDTO toHallDto(Hall hall, boolean onlyActiveTables) {
        HallDTO dto = HallMapper.toDto(hall);
        List<RestaurantTable> tables = onlyActiveTables
                ? tableRepository.findByHall_IdAndStatus(hall.getId(), "ACTIVE")
                : tableRepository.findByHall_Id(hall.getId());
        dto.setTables(mapTables(tables));
        return dto;
    }

    private List<Table> mapTables(List<RestaurantTable> tables) {
        return tables.stream().map(tableEntity -> {
            Table table = new Table();
            table.setTableId(tableEntity.getId());
            table.setTableName(tableEntity.getTableName());
            table.setStatus(tableEntity.getStatus());
            return table;
        }).toList();
    }

    private RestaurantUser findRestaurantUser(Long restaurantUserId) {
        if (restaurantUserId == null || restaurantUserId <= 0) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required");
        }

        return restaurantUserRepository.findById(restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required"));
    }

    private String normalizeName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Room / Hall name is required");
        }
        return name.trim();
    }

    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "ACTIVE";
        }
        String normalized = status.trim().toUpperCase(Locale.ROOT);
        if (!"ACTIVE".equals(normalized) && !"INACTIVE".equals(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Status must be ACTIVE or INACTIVE");
        }
        return normalized;
    }
}
