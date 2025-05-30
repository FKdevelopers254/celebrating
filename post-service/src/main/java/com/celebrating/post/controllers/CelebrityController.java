package com.celebrating.post.controllers;

import com.celebrating.post.models.Event;
import com.celebrating.post.services.CelebrityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/celebrities")
public class CelebrityController {

    @Autowired
    private CelebrityService celebrityService;

    @GetMapping("/{id}/events")
    public ResponseEntity<List<Event>> getCelebrityEvents(@PathVariable Long id) {
        return ResponseEntity.ok(celebrityService.getEventsByCelebrityId(id));
    }
}