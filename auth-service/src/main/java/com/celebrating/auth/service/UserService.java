package com.celebrating.auth.service;

import com.celebrating.auth.entity.User;
import com.celebrating.auth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerUser(User user) {
        System.out.println("Attempting to register user: " + user.getUsername()); // Debug log
        
        // Normalize username and email to lowercase
        user.setUsername(user.getUsername().toLowerCase());
        if (user.getEmail() != null) {
            user.setEmail(user.getEmail().toLowerCase());
        }
        
        // Check if username exists
        userRepository.findByUsername(user.getUsername()).ifPresent(existingUser -> {
            System.out.println("Username already exists: " + user.getUsername()); // Debug log
            throw new RuntimeException("Username already exists");
        });

        // Check if email exists
        if (user.getEmail() != null) {
            userRepository.findByEmail(user.getEmail()).ifPresent(existingUser -> {
                System.out.println("Email already exists: " + user.getEmail()); // Debug log
                throw new RuntimeException("Email already exists");
            });
        }

        // Encode password and save user
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        User savedUser = userRepository.save(user);
        System.out.println("User saved successfully with ID: " + savedUser.getId()); // Debug log
        return savedUser;
    }

    public User findByUsername(String username) {
        System.out.println("Looking up user by username: " + username); // Debug log
        // Normalize username to lowercase for lookup
        String normalizedUsername = username.toLowerCase();
        System.out.println("Normalized username for lookup: " + normalizedUsername); // Debug log
        return userRepository.findByUsername(normalizedUsername)
                .orElseThrow(() -> {
                    System.out.println("User not found by username: " + normalizedUsername); // Debug log
                    return new RuntimeException("User not found: " + username);
                });
    }

    public User findByUsernameOrEmail(String login) {
        System.out.println("Looking up user by username or email: " + login); // Debug log
        String normalizedLogin = login.toLowerCase();
        System.out.println("Normalized login for lookup: " + normalizedLogin); // Debug log
        
        // First try to find by username
        Optional<User> user = userRepository.findByUsername(normalizedLogin);
        if (user.isPresent()) {
            System.out.println("User found by username: " + normalizedLogin); // Debug log
            return user.get();
        }
        
        // Then try to find by email
        user = userRepository.findByEmail(normalizedLogin);
        if (user.isPresent()) {
            System.out.println("User found by email: " + normalizedLogin); // Debug log
            return user.get();
        }
        
        System.out.println("User not found by username or email: " + normalizedLogin); // Debug log
        throw new RuntimeException("User not found: " + login);
    }
}