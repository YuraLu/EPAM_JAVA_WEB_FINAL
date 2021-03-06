package by.epam.lukashevich.domain.command.impl.user;

import by.epam.lukashevich.domain.command.Command;
import by.epam.lukashevich.domain.command.exception.CommandException;
import by.epam.lukashevich.domain.command.impl.util.CheckMessage;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import static by.epam.lukashevich.domain.config.BeanFieldJsp.MESSAGE_TO_SIGN_UP;
import static by.epam.lukashevich.domain.config.JSPPage.SIGN_UP_PAGE;

public class CommandViewSignUp implements Command {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, CommandException {

        final HttpSession session = request.getSession();
        CheckMessage.checkMessageToJsp(session, request, MESSAGE_TO_SIGN_UP);
        return SIGN_UP_PAGE;
    }
}