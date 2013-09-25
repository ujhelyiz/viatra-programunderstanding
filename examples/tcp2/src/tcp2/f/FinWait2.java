package tcp2.f;

import tcp2.s.State;
import tcp2.t.TimeWait;

public class FinWait2 extends FinWaitState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new FinWait2();
		}
		return instance;
	}

	@Override
	public void run() {
		if (State.DEACTIVATE) {
			System.out.println("DEACTIVATED");
		} else {
			switch (getReceivedFlag()) {
			case FIN:
				send(Flag.ACK);
				TimeWait.Instance().activate();
				return;
			default:
				break;
			}
		}
	}
}
