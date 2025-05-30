package com.celebrating.post.repositories;

import com.celebrating.post.models.Post;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostRepository extends JpaRepository<Post, Long> {
}