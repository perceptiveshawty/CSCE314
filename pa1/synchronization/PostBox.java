// Sachin Chanchani
// UIN: 828004948
// CSCE 314

import java.util.*;

class PostBox implements Runnable {
    private final int MAX_SIZE;

    class Message {
        String sender;
        String recipient;
        String msg;
        Message(String sender, String recipient, String msg) {
            this.sender = sender;
            this.recipient = recipient;
            this.msg = msg;
        }
    }

    private final LinkedList<Message> messages;
    private LinkedList<Message> myMessages;
    private String myId;
    private volatile boolean stop = false;

    public PostBox(String myId, int max_size) {
        messages = new LinkedList<Message>();
        this.myId = myId;
        this.myMessages = new LinkedList<Message>();
        this.MAX_SIZE = max_size;
        new Thread(this).start();
    }

    public PostBox(String myId, int max_size, PostBox p) {
        this.myId = myId;
        this.messages = p.messages;
        this.MAX_SIZE = max_size;
        this.myMessages = new LinkedList<Message>();
        new Thread(this).start();
    }

    public String getId() { return myId; }

    public void stop() {
        // make it so that this Runnable will stop when it next wakes
        stop = true;
    }

    public void send(String recipient, String msg) {
        // add a message to the shared message queue
        synchronized (messages) {
          messages.add(new Message(myId, recipient, msg));
        }
    }

    public List<String> retrieve() {
        // return the contents of myMessages
        // and empty myMessages
        synchronized (myMessages) {
          List<String> contents = new ArrayList<String>();
          while (!myMessages.isEmpty()) {
            Message temp = myMessages.getFirst();
            temp = myMessages.removeFirst();
            contents.add("From " + temp.sender + " to " + temp.recipient + ": " + temp.msg);
          }
          return contents;
        }
    }

    public void download() {
      synchronized (messages) {
        int i = 0;
        while (i < messages.size()) {
          if (messages.get(i).recipient == myId) {
            synchronized (myMessages) {
              myMessages.add(messages.remove(i));
              i--;
            }
          }
          i++;
        }
      }
    }

    public void cleanup() {
      synchronized (messages) {
        while (messages.size() > MAX_SIZE) {
          messages.removeFirst();
        }
      }
      synchronized (myMessages) {
        while (myMessages.size() > MAX_SIZE) {
          myMessages.removeFirst();
        }
      }
    }

    public void run() {
        // loop while not stopped
        //   1. approximately once every second move all messages
        //      addressed to this post box from the shared message
        //      queue to the private myMessages queue
        //   2. also approximately once every second, if the private or
        //      shared message queue has more than MAX_SIZE messages,
        //      delete oldest messages so that the size of myMessages
        //      and messages is at most MAX_SIZE.
        while (!stop) {
          this.download();
          this.cleanup();
          try {Thread.sleep(1000);} catch (InterruptedException e) {}
        }
    }
}
