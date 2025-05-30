
package com.celebrating.post.services;

import com.celebrating.post.models.Event;
import com.celebrating.post.models.User;
import com.celebrating.post.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CelebrityService {

    @Autowired
    private UserRepository userRepository;

    public List<Event> getEventsByCelebrityId(Long id) {
        User celebrity = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Celebrity not found"));
        return celebrity.getEvents();
    }
}