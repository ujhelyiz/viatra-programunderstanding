package tcp2.s;

import tcp2.c.Closed;
import tcp2.e.Established;

public class SynSent extends SynState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new SynSent();
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

	@Override
	public void run() {
		if (!State.DEACTIVATE) {
			switch (getReceivedFlag()) {
			case SYN:
				send(Flag.SYN_ACK);
				SynReceived.Instance().activate();
				return;
			case SYN_ACK:
				send(Flag.ACK);
				Established.Instance().activate();
				return;
			default:
				break;
			}
		} else {
			System.out.println("DEACTIVATED");
		}
	}
}
