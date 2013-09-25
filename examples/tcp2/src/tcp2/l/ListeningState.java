package tcp2.l;

import tcp2.r.RunnableState;

public abstract class ListeningState extends RunnableState {
	final protected Flag getReceivedFlag() {
		return Flag.values()[(int) Math.round(Math.random()
				* Flag.values().length)];
		// return Math.random() < 0.5 ? Flag.ACK : Flag.FIN;
	}
}
