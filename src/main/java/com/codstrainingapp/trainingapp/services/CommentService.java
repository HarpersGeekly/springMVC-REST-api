package com.codstrainingapp.trainingapp.services;

import com.codstrainingapp.trainingapp.models.Comment;
import com.codstrainingapp.trainingapp.models.CommentDTO;
import com.codstrainingapp.trainingapp.repositories.CommentsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class CommentService {

    private CommentsRepository commentsDao;

    @Autowired
    public CommentService(CommentsRepository commentsDao) {
        this.commentsDao = commentsDao;
    }

    public List<CommentDTO> findAllByPostId(Long id) {
        List<Comment> comments = commentsDao.findAllByPostId(id);
        return getCommentDTOS(comments);
    }

    public List<CommentDTO> findAllByUserId(Long id) {
        List<Comment> comments = commentsDao.findAllByUserId(id);
        return getCommentDTOS(comments);
    }

    public List<CommentDTO> getCommentDTOS(List<Comment> comments) {
        List<CommentDTO> dtos = new ArrayList<>();
        for (Comment c : comments) {
            CommentDTO converted = convertToCommentDTO(c);
            dtos.add(converted);
        }
        return dtos;
    }

    public CommentDTO findOne(Long id) {
        Comment comment = commentsDao.findOne(id);
        return convertToCommentDTO(comment);
    }

    public CommentDTO saveComment(CommentDTO dto) {
        Comment entity = convertToComment(dto);
        commentsDao.saveComment(entity);
        return convertToCommentDTO(entity);
    }

    public CommentDTO delete(CommentDTO dto) { // void
        Comment comment = commentsDao.findOne(dto.getId());
//        commentsDao.delete(comment);
        comment.setHasBeenDeleted(true);
        return convertToCommentDTO(comment);
    }

    public CommentDTO convertToCommentDTO(Comment comment) {
        CommentDTO dto = new CommentDTO();
        dto.setId(comment.getId());
        dto.setBody(comment.getBody());
        dto.setUser(comment.getUser());
        dto.setDate(comment.getDate());
        dto.setHasBeenDeleted(comment.isHasBeenDeleted());
        return dto;
    }

    public Comment convertToComment(CommentDTO commentDto) {
        Comment entity = new Comment();
        entity.setId(commentDto.getId());
        entity.setUser(commentDto.getUser());
        entity.setBody(commentDto.getBody());
        entity.setDate(commentDto.getDate());
        entity.setPost(commentDto.getPost());
        entity.setHasBeenDeleted(commentDto.isHasBeenDeleted());
        return entity;
    }
}
