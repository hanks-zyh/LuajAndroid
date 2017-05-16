package androlua;

public abstract class TimerTaskX implements Runnable {
    final Object lock = new Object();
    boolean cancelled;
    boolean fixedRate;
    long period;
    long when;
    private boolean mEnabled;
    private long scheduledTime;

    protected TimerTaskX() {
    }

    public abstract void run();

    public long getPeriod() {
        return this.period;
    }

    public void setPeriod(long period) {
        this.period = period;
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

    public boolean isEnabled() {
        return this.mEnabled;
    }

    public void setEnabled(boolean enabled) {
        this.mEnabled = enabled;
    }
}
