package tcp2.c;

import tcp2.l.Listen;
import tcp2.r.RunnableState;
import tcp2.s.State;
import tcp2.s.SynSent;

public class Closed extends RunnableState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new Closed();
		}
		return instance;
	}

	public void listen() {
		if (!State.DEACTIVATE) {
			{
				{
					{
						{
							Listen.Instance().activate();
						}
					}
				}
			}
		} else {
			System.out.println("DEACTIVATED");
		}
	}

	public void connect() {
		if (!State.DEACTIVATE) {
			send(Flag.SYN);
			SynSent.Instance().activate();
		} else {
			System.out.println("DEACTIVATED");
		}
	}
}
