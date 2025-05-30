package com.celebrating.post.services;

import com.celebrating.post.models.Post;
import com.celebrating.post.repositories.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    public List<Post> getAllPosts() {
        return postRepository.findAll();
    }

    public void toggleLike(Long postId, String token) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));
        post.setLikes(post.getLikes() + 1); // Simplified
        postRepository.save(post);
    }

    public void addComment(Long postId, String comment, String token) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));
        post.setComments(post.getComments() + 1); // Simplified
        postRepository.save(post);
    }
}