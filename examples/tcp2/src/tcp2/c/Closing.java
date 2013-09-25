package tcp2.c;

import tcp2.l.ListeningState;
import tcp2.s.State;
import tcp2.t.TimeWait;

public class Closing extends ListeningState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new Closing();
		}
		return instance;
	}

	@Override
	public void run() {
		if (!State.DEACTIVATE) {
			switch (getReceivedFlag()) {
			case ACK:
				TimeWait.Instance().activate();
				return;
			default:
				break;
			}
		} else {
			System.out.println("DEACTIVATED");
		}
	}
}
