package tcp;

public class LastAck extends ListeningState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new LastAck();
		}
		return instance;
	}

	@Override
	protected void run() {
		switch (getReceivedFlag()) {
		case ACK:
			Closed.Instance().activate();
			return;
		default:
			break;
		}
	}
}
