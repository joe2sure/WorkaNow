import 'models/department_model.dart';
import 'models/query_message_model.dart';
import 'models/payment_model.dart';

class MockEmployerData {
  static List<DepartmentModel> getDepartments(String companyId) => [
    DepartmentModel(
      id: 'dept_001', name: 'Engineering',
      description: 'Software development and infrastructure',
      companyId: companyId,
      createdAt: DateTime(2024, 1, 1),
      staffCount: 2,
    ),
    DepartmentModel(
      id: 'dept_002', name: 'Design',
      description: 'UI/UX and visual communication',
      companyId: companyId,
      createdAt: DateTime(2024, 1, 1),
      staffCount: 1,
    ),
    DepartmentModel(
      id: 'dept_003', name: 'Product',
      description: 'Product strategy and roadmap',
      companyId: companyId,
      createdAt: DateTime(2024, 1, 1),
      staffCount: 1,
    ),
    DepartmentModel(
      id: 'dept_004', name: 'Analytics',
      description: 'Data analysis and reporting',
      companyId: companyId,
      createdAt: DateTime(2024, 1, 1),
      staffCount: 1,
    ),
  ];

  static List<QueryMessage> getQueryMessages(String companyId) => [
    QueryMessage(
      id: 'qry_001',
      staffId: 'staff_005',
      staffName: 'Tunde Adeyemi',
      employerId: 'employer_001',
      type: QueryType.lateArrival,
      subject: 'Query: Late Arrival on March 4, 2026',
      body: 'Dear Tunde, this is to formally notify you that you arrived '
          'at the office at 9:47 AM on March 4, 2026, which is 1 hour '
          '47 minutes after the official resumption time of 8:00 AM. '
          'Please provide a written explanation for this within 24 hours.',
      sentAt: DateTime.now().subtract(const Duration(days: 2)),
      status: QueryStatus.responded,
      staffResponse: 'I sincerely apologise for the late arrival. '
          'I experienced a severe traffic situation on Third Mainland Bridge '
          'due to an accident. This will not repeat itself.',
      respondedAt: DateTime.now().subtract(const Duration(days: 1)),
      relatedDate: DateTime.now().subtract(const Duration(days: 4)),
    ),
    QueryMessage(
      id: 'qry_002',
      staffId: 'staff_004',
      staffName: 'Fatima Bello',
      employerId: 'employer_001',
      type: QueryType.unauthorizedAbsence,
      subject: 'Query: Absence Without Prior Notice — March 3, 2026',
      body: 'Dear Fatima, our records indicate that you were absent from '
          'work on March 3, 2026 without prior approval or notification. '
          'This is a breach of our attendance policy. Please submit your '
          'explanation immediately.',
      sentAt: DateTime.now().subtract(const Duration(days: 3)),
      status: QueryStatus.read,
      relatedDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static List<MonthlyPayment> getPaymentHistory(String companyId) {
    final now = DateTime.now();
    final staffData = [
      ('staff_001', 'Emeka Obi', 'Senior Developer',
          'Engineering', 'EMP-001', 850000.0),
      ('staff_002', 'Amara Nwosu', 'UI/UX Designer',
          'Design', 'EMP-002', 720000.0),
      ('staff_003', 'Chidi Eze', 'Product Manager',
          'Product', 'EMP-003', 950000.0),
      ('staff_004', 'Fatima Bello', 'Data Analyst',
          'Analytics', 'EMP-004', 780000.0),
      ('staff_005', 'Tunde Adeyemi', 'Backend Developer',
          'Engineering', 'EMP-005', 800000.0),
    ];

    final List<MonthlyPayment> payments = [];
    for (int m = 0; m < 3; m++) {
      final month = now.month - m <= 0
          ? now.month - m + 12
          : now.month - m;
      final year = now.month - m <= 0 ? now.year - 1 : now.year;

      for (final s in staffData) {
        final (staffId, name, pos, dept, empId, salary) = s;
        final hasBonus = m == 1 && staffId == 'staff_001';
        final bonuses = hasBonus
            ? [const PaymentBonus(
                label: 'Q1 Performance Bonus', amount: 150000)]
            : <PaymentBonus>[];

        final deductions = [
          const PaymentDeduction(
              label: 'PAYE Tax', amount: 10, isPercentage: true),
          const PaymentDeduction(
              label: 'Pension (8%)', amount: 8, isPercentage: true),
          const PaymentDeduction(
              label: 'NHF', amount: 2.5, isPercentage: true),
        ];

        final gross = salary +
            bonuses.fold(0.0, (s, b) => s + b.amount);
        final totalDed = deductions.fold(
            0.0, (s, d) => s + d.computeFrom(gross));

        payments.add(MonthlyPayment(
          id: 'pay_${staffId}_${year}_$month',
          staffId: staffId,
          staffName: name,
          staffPosition: pos,
          staffDepartment: dept,
          employeeId: empId,
          companyId: companyId,
          payMonth: month,
          payYear: year,
          basicSalary: salary,
          bonuses: bonuses,
          deductions: deductions,
          grossPay: gross,
          totalDeductions: totalDed,
          netPay: gross - totalDed,
          status: m == 0
              ? PaymentStatus.recorded
              : PaymentStatus.paid,
          recordedAt: DateTime(year, month, 28),
          paidAt: m > 0 ? DateTime(year, month, 28) : null,
        ));
      }
    }
    return payments;
  }
}