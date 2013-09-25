package tcp2.s;

import tcp2.e.Established;
import tcp2.f.FinWait1;
import tcp2.l.Listen;

public class SynReceived extends SynState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new SynReceived();
		}
		return instance;
	}

	public void close() {
		if (!State.DEACTIVATE) {
			send(Flag.FIN);
			FinWait1.Instance().activate();
		} else {
			System.out.println("DEACTIVATED");
		}
	}

	@Override
	public void run() {
		if (!State.DEACTIVATE) {
			switch (getReceivedFlag()) {
			case ACK:
				Established.Instance().activate();
				return;
			case RST:
				Listen.Instance().activate();
				return;
			default:
				break;
			}
		} else {
			System.out.println("DEACTIVATED");
		}
	}
}
