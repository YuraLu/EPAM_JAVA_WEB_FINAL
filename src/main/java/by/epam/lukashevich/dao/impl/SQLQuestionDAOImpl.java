package by.epam.lukashevich.dao.impl;

import by.epam.lukashevich.dao.QuestionDAO;
import by.epam.lukashevich.dao.exception.DAOException;
import by.epam.lukashevich.dao.pool.connection.ConnectionWrapper;
import by.epam.lukashevich.dao.pool.connection.ProxyConnection;
import by.epam.lukashevich.dao.pool.impl.DatabaseConnectionPool;
import by.epam.lukashevich.dao.util.SQLUtil;
import by.epam.lukashevich.domain.entity.Answer;
import by.epam.lukashevich.domain.entity.Question;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static by.epam.lukashevich.dao.util.SQLQuery.*;

public class SQLQuestionDAOImpl implements QuestionDAO {

    private final DatabaseConnectionPool pool = DatabaseConnectionPool.getInstance();

    @Override
    public List<Question> findAll() throws DAOException {
        List<Question> questionList = new ArrayList<>();
        try (ProxyConnection proxyConnection = pool.getConnection();
             ConnectionWrapper con = proxyConnection.getConnectionWrapper();
             PreparedStatement st = con.prepareStatement(GET_ALL_QUESTIONS)) {

            ResultSet rs = st.executeQuery();

            Map<Question, List<Answer>> hashMap = getQuestionListMap(rs);

            for (Map.Entry<Question, List<Answer>> entry : hashMap.entrySet()) {
                Question item = entry.getKey();
                item.setAnswers(entry.getValue());
                questionList.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new DAOException("SQL Exception can't create list of questions in findAll()", e);
        }
        return questionList;
    }

    private Map<Question, List<Answer>> getQuestionListMap(ResultSet rs) throws SQLException {
        Map<Question, List<Answer>> hashMap = new HashMap<>();

        while (rs.next()) {
            Question question = SQLUtil.getQuestion(rs);
            Answer answer = SQLUtil.getAnswer(rs);

            if (!hashMap.containsKey(question)) {
                List<Answer> list = new ArrayList<>();
                list.add(answer);

                hashMap.put(question, list);
            } else {
                hashMap.get(question).add(answer);
            }
        }
        return hashMap;
    }

    @Override
    public Question findById(Integer id) throws DAOException {
        try (ProxyConnection proxyConnection = pool.getConnection();
             ConnectionWrapper con = proxyConnection.getConnectionWrapper();
             PreparedStatement st = con.prepareStatement(GET_QUESTION_BY_ID)) {

            st.setInt(1, id);
            ResultSet rs = st.executeQuery();

            Map<Question, List<Answer>> hashMap = getQuestionListMap(rs);
            Question question = null;
            for (Map.Entry<Question, List<Answer>> entry : hashMap.entrySet()) {
                question = entry.getKey();
                question.setAnswers(entry.getValue());
            }
            if (question != null) {
                return question;
            }
        } catch (SQLException e) {
            throw new DAOException("SQL Exception can't find question in findById()", e);
        }
        throw new DAOException("No question with ID=" + id + ".");
    }

    @Override
    public boolean add(Question question) throws DAOException {
        try (ProxyConnection proxyConnection = pool.getConnection();
             ConnectionWrapper con = proxyConnection.getConnectionWrapper();
             PreparedStatement st = con.prepareStatement(ADD_NEW_QUESTION)) {

            if (isTextUsed(con, question.getQuestionText())) {
                throw new DAOException("Text of question is already in use!");
            }
            st.setString(1, question.getQuestionText());
            st.executeUpdate();
            return true;
        } catch (SQLException e) {
            throw new DAOException("SQL Exception during add()", e);
        }
    }

    @Override
    public boolean update(Question question) throws DAOException {
    return false;
    }

    @Override
    public boolean delete(Integer id) throws DAOException {
        try (ProxyConnection proxyConnection = pool.getConnection();
             ConnectionWrapper con = proxyConnection.getConnectionWrapper();
             PreparedStatement st = con.prepareStatement(DELETE_QUESTION)) {
            st.setInt(1, id);
            st.executeUpdate();
            return true;
        } catch (SQLException e) {
            throw new DAOException("SQL Exception can't delete question with id=" + id, e);
        }
    }

    @Override
    public int addAndReturnId(Question question) throws DAOException {
        try (ProxyConnection proxyConnection = pool.getConnection();
             ConnectionWrapper con = proxyConnection.getConnectionWrapper();
             PreparedStatement st = con.prepareStatement(ADD_NEW_QUESTION, Statement.RETURN_GENERATED_KEYS)) {

//            if (isTextUsed(con, question.getQuestionText())) {
//                throw new DAOException("Text of question is already in use!");
//            }
            st.setString(1, question.getQuestionText());
            st.executeUpdate();

            try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("No ID obtained.");
                }
            }

        } catch (SQLException e) {
            throw new DAOException("SQL Exception during add()", e);
        }
    }

    @Override
    public List<Integer> addAnswersList(int questionId, List<Integer> answerIdsList) throws DAOException {
        try (ProxyConnection proxyConnection = pool.getConnection();
             ConnectionWrapper con = proxyConnection.getConnectionWrapper();
             PreparedStatement st = con.prepareStatement(ADD_ANSWERS_LIST_FOR_QUESTION_ID
                     , Statement.RETURN_GENERATED_KEYS)) {

            con.setAutoCommit(false);
            int[] executeResult = null;

            for (int i = 0; i < answerIdsList.size(); i++) {
                st.setInt(1, answerIdsList.get(i));
                st.setInt(2, questionId);
                st.addBatch();

                if (i % 3 == 0 || (i + 1) == answerIdsList.size()) {
                    executeResult = st.executeBatch(); // Execute every 4 items.
                }
            }
            st.executeBatch();
            con.commit();
            con.setAutoCommit(true);

            List<Integer> idsList = new ArrayList<>();
            ResultSet rs = st.getGeneratedKeys();
            if (rs != null) {
                while (rs.next()) {
                    idsList.add(rs.getInt(1));
                }
            } else {
                throw new SQLException("No ID obtained.");
            }

            return idsList;
        } catch (SQLException e) {
            throw new DAOException("SQL Exception during add()", e);
        }
    }

    private boolean isTextUsed(Connection connection, String text) throws SQLException {
        try (PreparedStatement st = connection.prepareStatement(GET_QUESTION_BY_TEXT)) {
            st.setString(1, text);
            ResultSet rs = st.executeQuery();
            return rs.first();
        }
    }
}