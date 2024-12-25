enum OrderStatus {
  paymentPending, // 0
  paymentPaid, // 1
  findingMechanic, // 2
  mechanicAssigned, // 4
  mechanicDispatched, // 5
  mechanicArrived, // 6
  serviceInProgress, // 7
  serviceCompleted, // 8
  serviceIncompleted, // 9
  orderCancelledByUser, // 20
  orderCancelledByMechanic
}

extension OrderStatusExtension on OrderStatus {
  int get value {
    switch (this) {
      case OrderStatus.paymentPending:
        return 0;
      case OrderStatus.paymentPaid:
        return 1;
      case OrderStatus.findingMechanic:
        return 2;
      case OrderStatus.mechanicAssigned:
        return 4;
      case OrderStatus.mechanicDispatched:
        return 5;
      case OrderStatus.mechanicArrived:
        return 6;
      case OrderStatus.serviceInProgress:
        return 7;
      case OrderStatus.serviceCompleted:
        return 8;
      case OrderStatus.serviceIncompleted:
        return 9;
      case OrderStatus.orderCancelledByUser:
        return 20;
      case OrderStatus.orderCancelledByMechanic:
        return 21;
    }
  }
}

extension OrderStatusExtensionNameGetter on OrderStatus {
  String get status {
    switch (this) {
      case OrderStatus.paymentPending:
        return "Payment Pending";
      case OrderStatus.paymentPaid:
        return "Payment Success";
      case OrderStatus.findingMechanic:
        return "Mechanic Discovery";
      case OrderStatus.mechanicAssigned:
        return "Mechanic Assigned";
      case OrderStatus.mechanicDispatched:
        return "Mechanic Departed";
      case OrderStatus.mechanicArrived:
        return "Mechanic Arrived";
      case OrderStatus.serviceInProgress:
        return "Service Started";
      case OrderStatus.serviceCompleted:
        return "Service Completed";
      case OrderStatus.serviceIncompleted:
        return "Service Incompleted";
      case OrderStatus.orderCancelledByUser:
        return "Cancelled";
      case OrderStatus.orderCancelledByMechanic:
        return "Cancelled";
    }
  }
}
