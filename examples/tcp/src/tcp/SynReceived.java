package tcp;

public class SynReceived extends ListeningState {
	private static State instance;

	public static State Instance() {
		if (instance == null) {
			instance = new SynReceived();
		}
		return instance;
	}

	public void close() {
		send(Flag.FIN);
		FinWait1.Instance().activate();
	}

	@Override
	protected void run() {
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
	}
}
