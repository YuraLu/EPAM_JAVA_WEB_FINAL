package by.epam.lukashevich.domain.service.provider;


import by.epam.lukashevich.domain.service.*;
import by.epam.lukashevich.domain.service.impl.*;

public class ServiceProvider {

    private static final ServiceProvider instance = new ServiceProvider();

    private final AnswerService answerService = new AnswerServiceImpl();
    private final AssignmentService assignmentService = new AssignmentServiceImpl();
    private final QuestionService questionService = new QuestionServiceImpl();
    private final ReplyService replyService = new ReplyServiceImpl();
    private final SubjectService subjectService = new SubjectServiceImpl();
    private final TestService testService = new TestServiceImpl();
    private final UserService userService = new UserServiceImpl();

    private ServiceProvider() {
    }

    public static ServiceProvider getInstance() {
        return instance;
    }

    public AnswerService getAnswerService() {
        return answerService;
    }

    public AssignmentService getAssignmentService() {
        return assignmentService;
    }

    public QuestionService getQuestionService() {
        return questionService;
    }

    public ReplyService getReplyService() {
        return replyService;
    }

    public SubjectService getSubjectService() {
        return subjectService;
    }

    public TestService getTestService() {
        return testService;
    }

    public UserService getUserService() {
        return userService;
    }
}