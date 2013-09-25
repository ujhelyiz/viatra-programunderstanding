package tcp2.c;

import tcp2.l.LastAck;
import tcp2.r.RunnableState;
import tcp2.s.State;

public class CloseWait extends RunnableState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new CloseWait();
		}
		return instance;
	}

	public void close() {
		if (State.DEACTIVATE) {
			System.out.println("DEACTIVATED");
		} else {
			send(Flag.FIN);
			LastAck.Instance().activate();
		}
	}
}
