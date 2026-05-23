package com.hms.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hms.dto.ItemDto;
import com.hms.dto.SubItemDto;

@RestController
@CrossOrigin 
public class ItemsController {
	
	// 👉 Get all items with sub-items
    @GetMapping("/items")
    public ItemDto getItems() {

        List<ItemDto> items = new ArrayList<>();

        // ✅ Biryani (with sub-items)
        ItemDto biryani = new ItemDto();
        biryani.setId(1);
        biryani.setName("Biryani");
        biryani.setPrice(100);

        List<SubItemDto> biryaniSubs = new ArrayList();

        SubItemDto full = new SubItemDto();
        full.setId(11);
        full.setName("Full");
        full.setPrice(250);

        SubItemDto half = new SubItemDto();
        half.setId(12);
        half.setName("Half");
        half.setPrice(150);
        
        SubItemDto single = new SubItemDto();
        single.setId(12);
        single.setName("Single");
        single.setPrice(100);


        SubItemDto familyPack = new SubItemDto();
        familyPack.setId(12);
        familyPack.setName("Family Pack");
        familyPack.setPrice(750);
        
        SubItemDto co = new SubItemDto();
        co.setId(12);
        co.setName("Cambo Pack");
        co.setPrice(1000);

        biryaniSubs.add(full);
        biryaniSubs.add(half);
        biryaniSubs.add(familyPack);
        biryaniSubs.add(single);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        biryaniSubs.add(co);
        
        

        biryani.setSubItems(biryaniSubs);

       

        return biryani;
    }

}
