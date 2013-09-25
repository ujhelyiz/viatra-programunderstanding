package tcp2.l;

import tcp2.c.Closed;
import tcp2.s.State;
import tcp2.s.SynReceived;
import tcp2.s.SynSent;

public class Listen extends ListeningState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new Listen();
		}
		return instance;
	}

	public void close() {
		if (State.DEACTIVATE) {
			System.out.println("DEACTIVATED");
		} else {
			Closed.Instance().activate();
		}
	}

	public void send() {
		if (!State.DEACTIVATE) {
			send(Flag.SYN);
			SynSent.Instance().activate();
		} else {
			System.out.println("DEACTIVATED");
		}
	}

	@Override
	public void run() {
		if (!State.DEACTIVATE) {
			switch (getReceivedFlag()) {
			case SYN:
				send(Flag.SYN_ACK);
				SynReceived.Instance().activate();
				return;
			default:
				break;
			}
		} else {
			System.out.println("DEACTIVATED");
		}
	}

}
