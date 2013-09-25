package tcp2.l;

import tcp2.c.Closed;
import tcp2.s.State;

public class LastAck extends ListeningState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new LastAck();
		}
		return instance;
	}

	@Override
	public void run() {
		if (!State.DEACTIVATE) {
			switch (getReceivedFlag()) {
			case ACK:
				Closed.Instance().activate();
				return;
			default:
				break;
			}
		} else {
			System.out.println("DEACTIVATED");
		}
	}
}
