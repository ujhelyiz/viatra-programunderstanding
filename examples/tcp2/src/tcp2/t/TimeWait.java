package tcp2.t;

import tcp2.c.Closed;
import tcp2.r.RunnableState;
import tcp2.s.State;

public class TimeWait extends RunnableState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new TimeWait();
		}
		return instance;
	}

	public void timeWait() throws TimeoutException {
		try {
			Thread.sleep(3);
		} catch (InterruptedException e) {
		}
		throw new TimeoutException();
	}

	@Override
	public void run() {
		if (State.DEACTIVATE) {
			System.out.println("DEACTIVATED");
		} else {
			try {
				timeWait();
			} catch (TimeoutException e) {
				Closed.Instance().activate();
			}
		}
	}
}
