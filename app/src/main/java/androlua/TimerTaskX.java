package androlua;

public abstract class TimerTaskX implements Runnable {
    boolean cancelled;
    boolean fixedRate;
    final Object lock = new Object();
    private boolean mEnabled;
    long period;
    private long scheduledTime;
    long when;

    public abstract void run();

    public void setPeriod(long period) {
        this.period = period;
    }

    public long getPeriod() {
        return this.period;
    }

    long getWhen() {
        long j;
        synchronized (this.lock) {
            j = this.when;
        }
        return j;
    }

    public void setScheduledTime(long time) {
        synchronized (this.lock) {
            this.scheduledTime = time;
        }
    }

    boolean isScheduled() {
        boolean z;
        synchronized (this.lock) {
            z = this.when > 0 || this.scheduledTime > 0;
        }
        return z;
    }

    protected TimerTaskX() {
    }

    public boolean cancel() {
        boolean willRun = true;
        synchronized (this.lock) {
            if (this.cancelled || this.when <= 0) {
                willRun = false;
            }
            this.cancelled = true;
        }
        return willRun;
    }

    public long scheduledExecutionTime() {
        long j;
        synchronized (this.lock) {
            j = this.scheduledTime;
        }
        return j;
    }

    public void setEnabled(boolean enabled) {
        this.mEnabled = enabled;
    }

    public boolean isEnabled() {
        return this.mEnabled;
    }
}
