package by.epam.lukashevich.domain.command.impl.test;

import by.epam.lukashevich.domain.command.Command;
import by.epam.lukashevich.domain.command.exception.CommandException;
import by.epam.lukashevich.domain.entity.Assignment;
import by.epam.lukashevich.domain.entity.Question;
import by.epam.lukashevich.domain.entity.Test;
import by.epam.lukashevich.domain.entity.user.User;
import by.epam.lukashevich.domain.service.QuestionService;
import by.epam.lukashevich.domain.service.TestService;
import by.epam.lukashevich.domain.service.UserService;
import by.epam.lukashevich.domain.service.exception.ServiceException;
import by.epam.lukashevich.domain.service.provider.ServiceProvider;
import by.epam.lukashevich.domain.util.builder.impl.AssignmentBuilderImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import static by.epam.lukashevich.domain.config.BeanFieldJsp.*;
import static by.epam.lukashevich.domain.config.JSPPage.PASS_TEST_PAGE;

/**
 * Shows pass test page
 *
 * @author Lukashevich_Y_A
 */
public class CommandViewPassTestPage implements Command {

    private TestService testService = ServiceProvider.getInstance().getTestService();
    private QuestionService questionService = ServiceProvider.getInstance().getQuestionService();
    private UserService userService = ServiceProvider.getInstance().getUserService();

    public void setTestService(TestService testService) {
        this.testService = testService;
    }

    public void setQuestionService(QuestionService questionService) {
        this.questionService = questionService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, CommandException {

        final HttpSession session = request.getSession();
        final int userId = (int) session.getAttribute(USER_ID);
        final int testId = Integer.parseInt(request.getParameter(TEST_ID));

        try {
            final Test test = testService.findById(testId);
            final List<Question> questionList = questionService.findAllQuestionsForTestId(testId);
            test.setQuestions(questionList);
            final int numberOfQuestions = questionList.size();

            final User user = userService.findById(userId);

            final Assignment assignment = new AssignmentBuilderImpl()
                    .withTest(test)
                    .withUser(user)
                    .build();

            int firstQuestion = 0;
            session.setAttribute(CURRENT_QUESTION_NUMBER, firstQuestion);
            session.setAttribute(NUMBER_OF_QUESTIONS, numberOfQuestions);
            session.setAttribute(ASSIGNMENT_OBJECT, assignment);

        } catch (ServiceException e) {
            throw new CommandException("Can't get test/user in execute() CommandViewPassTestPage", e);
        }

        return PASS_TEST_PAGE;
    }
}