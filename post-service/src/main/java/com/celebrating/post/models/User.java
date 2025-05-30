package com.celebrating.post.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "\"user\"")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ElementCollection
    private List<Event> events;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public List<Event> getEvents() { return events; }
    public void setEvents(List<Event> events) { this.events = events; }
}