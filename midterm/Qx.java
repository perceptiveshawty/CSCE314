


public void enter(boolean bachelorette) {
  try {
    while (true) { // TODO: fix me below
      cond.await();
    }

    venueLock.lock();

    if (bachelorette)
      status = VenueStatus.OCC_BACH;
    else
      status = VenueStatus.OCC_GEN;

    groups++; // Record a group entered

    venueLock.signalAll();

  } catch (InterruptedException e) {} finally {venueLock.unlock();}
}
