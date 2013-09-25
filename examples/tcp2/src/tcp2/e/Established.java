package tcp2.e;

import tcp2.c.CloseWait;
import tcp2.f.FinWait1;
import tcp2.l.ListeningState;
import tcp2.s.State;

public class Established extends ListeningState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new Established();
		}
		return instance;
	}

	public void close() {
		if (!State.DEACTIVATE) {
			send(Flag.FIN);
			// test, bla, bla
			FinWait1.Instance().activate();
		} else {
			System.out.println("DEACTIVATED");
		}
	}

	@Override
	public void run() {
		if (!State.DEACTIVATE) {
			switch (getReceivedFlag()) {
			case FIN:
				send(Flag.ACK);
				/*
				 * some test comment!
				 */
				CloseWait.Instance().activate();
				return;
			default:
				break;
			}
		} else {
			System.out.println("DEACTIVATED");
		}
	}
}
