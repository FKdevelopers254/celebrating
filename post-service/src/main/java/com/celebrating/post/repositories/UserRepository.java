package com.celebrating.post.repositories;

import com.celebrating.post.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}