package com.hms.controller;


import java.util.Arrays;
import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.hms.dto.MenuItem;

@RestController
@CrossOrigin 
public class MenuController {

	@RequestMapping(value="/leftMenu", method = RequestMethod.GET)
    public List<MenuItem> getMenu() {

        return Arrays.asList(
                new MenuItem("Sweet Corn Soup", 1),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Tomato Soup", 2),
                new MenuItem("Mushroom Soup", 3)
        );
    }
    
	@RequestMapping(value="/getMenuItem", method = RequestMethod.GET)
    public List<MenuItem> getMenuItem() {

        return Arrays.asList(
                new MenuItem("Sweet Corn Soup", 1)
                
        );
    }
}