package tcp2.s;

public abstract class State {
	public static boolean DEACTIVATE = false;
	private static State activeState = null;

	protected boolean isActive() {
		return activeState == this;
	}

	public final void activate() {
		synchronized (activeState) {
			activeState = this;
		}
	}

	public enum Flag {
		SYN, ACK, FIN, RST, SYN_ACK, FIN_ACK
	}

	final protected void send(Flag flag) {
		System.out.println(this.getClass().getSimpleName() + " sends "
				+ flag.toString());
	}

}
