package tcp2.f;

import tcp2.c.Closing;
import tcp2.s.State;
import tcp2.t.TimeWait;

public class FinWait1 extends FinWaitState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new FinWait1();
		}
		return instance;
	}

	@Override
	public void run() {
		if (!State.DEACTIVATE) {
			switch (getReceivedFlag()) {
			case ACK:
				FinWait2.Instance().activate();
				return;
			case FIN:
				send(Flag.ACK);
				Closing.Instance().activate();
				return;
			case FIN_ACK:
				send(Flag.ACK);
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
