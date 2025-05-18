package com.celebrating.auth.controller;

import com.celebrating.auth.entity.User;
import com.celebrating.auth.service.JwtService;
import com.celebrating.auth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = {"http://localhost:*", "http://127.0.0.1:*", "chrome-extension://*"},
             allowedHeaders = {"Authorization", "Content-Type", "X-Requested-With", "Accept", "Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"},
             exposedHeaders = {"Access-Control-Allow-Origin", "Access-Control-Allow-Credentials", "Authorization"},
             allowCredentials = "true")
public class AuthController {
    @Autowired
    private UserService userService;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        try {
            System.out.println("Registering user: " + user.getUsername()); // Debug log
            User registeredUser = userService.registerUser(user);
            System.out.println("User registered successfully: " + registeredUser.getUsername()); // Debug log
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Registration successful",
                "user", Map.of(
                    "id", registeredUser.getId(),
                    "username", registeredUser.getUsername(),
                    "email", registeredUser.getEmail()
                )
            ));
        } catch (RuntimeException e) {
            System.out.println("Registration failed: " + e.getMessage()); // Debug log
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Registration failed",
                "details", e.getMessage()
            ));
        } catch (Exception e) {
            System.out.println("Unexpected error during registration: " + e.getMessage()); // Debug log
            return ResponseEntity.status(500).body(Map.of(
                "success", false,
                "message", "An unexpected error occurred",
                "details", e.getMessage()
            ));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User user) {
        try {
            String loginIdentifier = user.getUsername() != null ? user.getUsername().toLowerCase() : "";
            System.out.println("Login attempt with identifier: " + loginIdentifier); // Debug log
            System.out.println("Password provided: " + (user.getPassword() != null ? "yes" : "no")); // Debug log

            if (loginIdentifier.isEmpty()) {
                System.out.println("Login failed: Empty login identifier"); // Debug log
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Login identifier required",
                    "details", "Please provide a username or email"
                ));
            }

            if (user.getPassword() == null || user.getPassword().isEmpty()) {
                System.out.println("Login failed: Empty password"); // Debug log
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Password required",
                    "details", "Please provide a password"
                ));
            }

            try {
                // Try to find user by username or email
                User existingUser = userService.findByUsernameOrEmail(loginIdentifier);
                System.out.println("Found user: " + existingUser.getUsername() + ", Email: " + existingUser.getEmail()); // Debug log
                System.out.println("Stored password hash: " + existingUser.getPassword()); // Debug log

                // Check password
                boolean passwordMatches = passwordEncoder.matches(user.getPassword(), existingUser.getPassword());
                System.out.println("Password match result: " + passwordMatches); // Debug log

                if (passwordMatches) {
                    String token = jwtService.generateToken(existingUser.getUsername());
                    System.out.println("Password matched, generated token for user: " + existingUser.getUsername()); // Debug log
                    
                    return ResponseEntity.ok(Map.of(
                        "success", true,
                        "message", "Login successful",
                        "token", token,
                        "user", Map.of(
                            "username", existingUser.getUsername(),
                            "email", existingUser.getEmail()
                        )
                    ));
                } else {
                    System.out.println("Password mismatch for user: " + existingUser.getUsername()); // Debug log
                    return ResponseEntity.status(401).body(Map.of(
                        "success", false,
                        "message", "Invalid credentials",
                        "details", "The password is incorrect"
                    ));
                }
            } catch (RuntimeException e) {
                System.out.println("User not found with identifier: " + loginIdentifier); // Debug log
                return ResponseEntity.status(404).body(Map.of(
                    "success", false,
                    "message", "User not found",
                    "details", "No account exists with the provided username or email"
                ));
            }
        } catch (Exception e) {
            System.out.println("Unexpected error during login: " + e.getMessage()); // Debug log
            e.printStackTrace(); // Print stack trace for debugging
            return ResponseEntity.status(500).body(Map.of(
                "success", false,
                "message", "Login failed",
                "details", "An unexpected error occurred during login"
            ));
        }
    }
}