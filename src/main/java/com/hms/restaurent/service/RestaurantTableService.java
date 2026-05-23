package com.hms.restaurent.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.hms.entity.restaurent.Hall;
import com.hms.entity.restaurent.RestaurantTable;
import com.hms.restaurent.dto.RestaurantTableDTO;
import com.hms.restaurent.mapper.RestaurantTableMapper;
import com.hms.restaurent.repository.HallRepository;
import com.hms.restaurent.repository.TableRepository;

@Service
public class RestaurantTableService {

    @Autowired
    private TableRepository tableRepository;

    @Autowired
    private HallRepository hallRepository;

    public RestaurantTableDTO save(RestaurantTableDTO dto, Long restaurantUserId) {
        String tableName = normalizeTableName(dto.getTableName());
        String status = normalizeStatus(dto.getStatus());
        Long hallId = normalizeHallId(dto.getHallId());

        Hall hall = hallRepository.findByIdAndRestaurantUser_Id(hallId, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Room / Hall not found"));

        if (tableRepository.existsByTableNameIgnoreCaseAndHall_IdAndHall_RestaurantUser_Id(tableName, hallId, restaurantUserId)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Table already exists in selected room / hall");
        }

        dto.setTableName(tableName);
        dto.setStatus(status);

        RestaurantTable entity = RestaurantTableMapper.toEntity(dto, hall);
        entity.setId(null);

        RestaurantTable saved = tableRepository.save(entity);
        return RestaurantTableMapper.toDto(saved);
    }

    public List<RestaurantTableDTO> findAll(Long hallId, String status, Long restaurantUserId) {
        List<RestaurantTable> tables;

        if (hallId != null && hasValue(status)) {
            tables = tableRepository.findByHall_RestaurantUser_IdAndHall_IdAndStatus(
                    restaurantUserId,
                    hallId,
                    normalizeStatus(status));
        } else if (hallId != null) {
            tables = tableRepository.findByHall_RestaurantUser_IdAndHall_Id(restaurantUserId, hallId);
        } else if (hasValue(status)) {
            tables = tableRepository.findByHall_RestaurantUser_IdAndStatus(restaurantUserId, normalizeStatus(status));
        } else {
            tables = tableRepository.findByHall_RestaurantUser_Id(restaurantUserId);
        }

        return tables.stream().map(RestaurantTableMapper::toDto).toList();
    }

    public RestaurantTableDTO findById(Long id, Long restaurantUserId) {
        RestaurantTable entity = tableRepository.findByIdAndHall_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Table not found"));

        return RestaurantTableMapper.toDto(entity);
    }

    public RestaurantTableDTO update(Long id, RestaurantTableDTO dto, Long restaurantUserId) {
        String tableName = normalizeTableName(dto.getTableName());
        String status = normalizeStatus(dto.getStatus());
        Long hallId = normalizeHallId(dto.getHallId());

        RestaurantTable entity = tableRepository.findByIdAndHall_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Table not found"));

        Hall hall = hallRepository.findByIdAndRestaurantUser_Id(hallId, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Room / Hall not found"));

        if (tableRepository.existsByTableNameIgnoreCaseAndHall_IdAndHall_RestaurantUser_IdAndIdNot(
                tableName,
                hallId,
                restaurantUserId,
                id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Table already exists in selected room / hall");
        }

        dto.setTableName(tableName);
        dto.setStatus(status);

        RestaurantTableMapper.updateEntity(entity, dto, hall);
        RestaurantTable updated = tableRepository.save(entity);

        return RestaurantTableMapper.toDto(updated);
    }

    public void delete(Long id, Long restaurantUserId) {
        RestaurantTable entity = tableRepository.findByIdAndHall_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Table not found"));
        tableRepository.delete(entity);
    }

    private String normalizeTableName(String tableName) {
        if (!hasValue(tableName)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Table name is required");
        }
        return tableName.trim();
    }

    private Long normalizeHallId(Long hallId) {
        if (hallId == null || hallId <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Room / Hall is required");
        }
        return hallId;
    }

    private String normalizeStatus(String status) {
        if (!hasValue(status)) {
            return "ACTIVE";
        }

        String normalized = status.trim().toUpperCase(Locale.ROOT);
        if (!"ACTIVE".equals(normalized) && !"INACTIVE".equals(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Status must be ACTIVE or INACTIVE");
        }
        return normalized;
    }

    private boolean hasValue(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
