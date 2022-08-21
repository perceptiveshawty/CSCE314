import javax.swing.*;

public class MIS3370Quiz2Spring2021D {
  public static void main(String[] args) {
    JFrame frame = new JFrame();
    int PurchCt = Integer.valueOf(JOptionPane.showInputDialog(frame, "How many purchases did you have on your Business Trip?"));

    BusinessPurchases[] items = new BusinessPurchases[PurchCt];

    for (int i = 0; i < PurchCt; ++i) {

      // JFrame frame = new JFrame();
      // JFrame inCrCd = new JFrame();
      // JFrame inLoCr = new JFrame();

      String desc = JOptionPane.showInputDialog(frame, "What did you purchase?");
      String curr = method3(JOptionPane.showInputDialog(frame, "In which currency (GBP or Euro)?"));

      if (method4(curr)) {
        double price = Double.valueOf(JOptionPane.showInputDialog(frame, "What was the purchase price in " + curr + " ?"));
        double conver = Double.valueOf(JOptionPane.showInputDialog(frame, "What was the exchange rate for this purchase?"));

        items[i] = new BusinessPurchases(curr, conver, desc, price);
      } else {
        JOptionPane.showMessageDialog(frame, "Invalid currency code");
        continue;
      }
    }
  }

  public static void method2(BusinessPurchases[] inList) {
    int total = 0;

    for (BusinessPurchases each : inList) {
      total += Integer.parseInt(each.getUSD());
      JOptionPane.showMessageDialog(frame, "Item Purchased: " + each.getItem() + "\n" +
                                    "Currency Code: " + super.each.getCurrCode() + "\n" +
                                    "Amount Spent: " + each.getLocal() + "\n" +
                                    "Exchange Rate: " + super.each.getExchRate() + "\n" +
                                    "Converted to USD: " + each.getUSD());
    }

    JOptionPane.showMessageDialog(frame, "You spent " + String.valueOf(total) + "USD on your business trip");
  }



  public static String method3(String in) {
    return in.replaceAll("[^GBPEURO]", ""); // regex expression, found method in https://stackoverflow.com/questions/46697010/how-to-remove-all-but-certain-characters-from-a-string-in-java
  }

  public static boolean method4(String infrom3) {

    switch (infrom3) {
      case "GBP":
        return true;
      case "EURO":
        return true;
      default:
        return false;
    }

  }

}

class BusinessPurchases extends Currency {

  public String itemPurchased;
  public double purchaseAmtLCL;
  public double purchaseAmtUSD;

  BusinessPurchases(String currCode, double exchRate, String itemPurch, double purchAmt) {
    super.Currency(currCode, exchRate);
    this.itemPurchased = itemPurch;
    this.purchaseAmtLCL = purchAmt;
    this.purchaseAmtUSD = purchAmt * exchRate;
  }

  public String getUSD() {
    return String.valueOf(this.purchaseAmtUSD);
  }

  public String getLocal() {
    return String.valueOf(this.purchaseAmtLCL);
  }

  public String getItem() {
    return this.itemPurchased;
  }

}

class Currency {

  private String currCode;
  private double exchRate;

  public void Currency(String currCode, double exchRate) {
    this.currCode = currCode;
    this.exchRate = exchRate;
  }

  public String getCurrCode() {
    return this.currCode;
  }

  public double getExchRate() {
    return this.exchRate;
  }
}
