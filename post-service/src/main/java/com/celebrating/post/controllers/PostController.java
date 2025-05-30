package com.celebrating.post.controllers;

import com.celebrating.post.models.Post;
import com.celebrating.post.services.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/posts")
public class PostController {

    @Autowired
    private PostService postService;

    @GetMapping
    public ResponseEntity<List<Post>> getAllPosts() {
        return ResponseEntity.ok(postService.getAllPosts());
    }

    @PostMapping("/{postId}/like")
    public ResponseEntity<Void> likePost(@PathVariable Long postId, @RequestHeader("Authorization") String token) {
        postService.toggleLike(postId, token);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{postId}/comment")
    public ResponseEntity<Void> addComment(
            @PathVariable Long postId,
            @RequestHeader("Authorization") String token,
            @RequestBody Map<String, String> body
    ) {
        String comment = body.get("comment");
        postService.addComment(postId, comment, token);
        return ResponseEntity.ok().build();
    }
}