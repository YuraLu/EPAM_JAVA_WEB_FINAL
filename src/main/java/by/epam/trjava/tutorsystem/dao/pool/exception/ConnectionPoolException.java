package by.epam.trjava.tutorsystem.dao.pool.exception;

public class ConnectionPoolException extends Throwable {
    public ConnectionPoolException(String message) {
        super(message);
    }

    public ConnectionPoolException(String message, Throwable cause) {
        super(message, cause);
    }
}
