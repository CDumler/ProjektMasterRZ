const Map<String, List<String>> controlReferenceMapping =
    <String, List<String>>{
  'A-CTRL-01': <String>[
    'EN 50600-2-2 6.2.6 / 6.3.4',
    'ISO/IEC 27002:2022 8.14',
    'NIST SP 800-53 PE-9(1)',
  ],
  'A-CTRL-02': <String>[
    'EN 50600-2-2 6.2 / 6.2.5 / 6.2.6',
    'BSI INF.2.A13',
    'NIST SP 800-53 PE-11',
  ],
  'A-CTRL-03': <String>[
    'BSI INF.2.A14',
    'NIST SP 800-53 PE-11',
    'EN 50600-2-2 6.2',
  ],
  'A-CTRL-04': <String>[
    'BSI INF.2.A19',
    'NIST SP 800-53 CP-4',
    'ISO 22301:2019 8.5',
  ],
  'A-CTRL-05': <String>[
    'EN 50600-2-3 / ISO/IEC 22237-4 6.2.2 / 6.4',
    'BSI INF.2.A16',
    'NIST SP 800-53 PE-14',
  ],
  'A-CTRL-06': <String>[
    'EN 50600-2-3 / ISO/IEC 22237-4 5.2.9 / 6.2.2',
    'BSI INF.2.A16',
    'ISO/IEC 27002:2022 7.8',
  ],
  'A-CTRL-07': <String>[
    'EN 50600-2-3 / ISO/IEC 22237-4 6.3 / 6.4',
    'ISO/IEC 27002:2022 8.6',
    'BSI INF.2.A16',
  ],
  'A-CTRL-08': <String>[
    'EN 50600-2-5 8.1.3',
    'BSI INF.2.A8',
    'BSI INF.2.A17',
  ],
  'A-CTRL-09': <String>[
    'EN 50600-2-5 8.1.4 / 8.2',
    'BSI INF.2.A9',
    'NIST SP 800-53 PE-13',
  ],
  'A-CTRL-10': <String>[
    'EN 50600-3-1 7.2 / Annex B.2',
    'BSI INF.2.A10',
    'ISO/IEC 27002:2022 7.13',
  ],
  'A-CTRL-11': <String>[
    'ISO/IEC 22237-2 8.9 / 10.1',
    'BSI INF.2.A11 / A29',
    'NIST SP 800-53 PE-15',
  ],
  'A-CTRL-12': <String>[
    'ISO/IEC 22237-2 8.7 / 8.10 / 8.11 / 8.13',
    'BSI INF.2.A7',
    'ISO/IEC 27002:2022 7.8',
  ],
  'A-CTRL-13': <String>[
    'ISO/IEC 22237-2 5.3.3 / 8.8 / 8.9 / 9.4 / 9.5',
    'BSI INF.1.A15',
    'BSI INF.2.A29',
  ],
  'A-CTRL-14': <String>[
    'ISO/IEC 27001:2022 5.3 / 7.2',
    'BSI ORP.1.A2',
    'BSI ORP.2.A15',
  ],
  'A-CTRL-15': <String>[
    'BSI INF.2.A10 / INF.12.A12',
    'ISO/IEC 27002:2022 7.13',
    'NIST SP 800-53 MA-2',
  ],
  'A-CTRL-16': <String>[
    'EN 50600-3-1 7.2 / 7.4',
    'BSI INF.12.A12',
    'NIST SP 800-53 MA-2',
  ],
  'A-CTRL-17': <String>[
    'BSI INF.2.A5',
    'ISO/IEC 22237-4 8.2 / 8.3 / Annex A',
    'NIST SP 800-53 PE-14',
  ],
  'B-CTRL-01': <String>[
    'ISO/IEC 27002:2022 7.2',
    'NIST SP 800-53 PE-2',
    'BSI INF.2.A6',
  ],
  'B-CTRL-02': <String>[
    'EN 50600-2-5 6.1.2 / 6.1.4',
    'NIST SP 800-53 PE-3',
    'ISO/IEC 27002:2022 7.2',
  ],
  'B-CTRL-03': <String>[
    'ISO/IEC 27002:2022 5.18',
    'ISO/IEC 27001:2022 5.3',
    'NIST SP 800-53 PE-2',
  ],
  'B-CTRL-04': <String>[
    'ISO/IEC 27002:2022 7.1',
    'EN 50600-2-5 5.3 / 6.2',
    'BSI INF.2.A12',
  ],
  'B-CTRL-05': <String>[
    'EN 50600-2-5 6.2 / 7',
    'ISO/IEC 27002:2022 7.1 / 7.2',
    'BSI INF.2.A12',
  ],
  'B-CTRL-06': <String>[
    'NIST SP 800-53 PE-16',
    'EN 50600-2-5 6.2.4 / 6.2.7',
    'ISO/IEC 27002:2022 7.1 / 7.2',
  ],
  'B-CTRL-07': <String>[
    'ISO/IEC 27002:2022 7.4',
    'NIST SP 800-53 PE-6',
    'EN 50600-2-5 11.2.2 / 11.2.5',
  ],
  'B-CTRL-08': <String>[
    'ISO/IEC 27002:2022 5.33',
    'ISO/IEC 27002:2022 8.3',
    'NIST SP 800-53 AC-6',
  ],
  'B-CTRL-09': <String>[
    'ISO/IEC 27002:2022 5.34',
    'ISO/IEC 27002:2022 8.10',
    'BSI CON.6.A2',
  ],
  'B-CTRL-10': <String>[
    'NIST SP 800-53 PE-8',
    'ISO/IEC 22237-6 6.2.6',
    'BSI INF.1.A26',
  ],
  'B-CTRL-11': <String>[
    'ISO/IEC 27002:2022 5.19 / 5.20',
    'NIST SP 800-53 PS-7',
    'BSI ORP.1.A14',
  ],
  'B-CTRL-12': <String>[
    'ISO/IEC 27002:2022 5.15 / 7.2',
    'NIST SP 800-53 PE-16',
    'BSI INF.1.A26',
  ],
  'B-CTRL-13': <String>[
    'ISO/IEC 27002:2022 7.1 / 7.2',
    'NIST SP 800-53 PE-3 / PE-18',
    'EN 50600-2-5 6.2 / 7',
  ],
  'B-CTRL-14': <String>[
    'ISO/IEC 27002:2022 7.2',
    'NIST SP 800-53 PE-3(1)',
    'BSI INF.2.A6 / INF.2.A12',
  ],
  'B-CTRL-15': <String>[
    'EN 50600-2-5 6.1.4 / 6.2',
    'NIST SP 800-53 PE-3',
    'ISO/IEC 27002:2022 7.2',
  ],
  'C-CTRL-01': <String>[
    'ISO/IEC 27002:2022 8.16',
    'NIST SP 800-53 SI-4',
    'EN 50600-3-1 6 / 7',
  ],
  'C-CTRL-02': <String>[
    'ISO/IEC 27002:2022 8.16',
    'NIST SP 800-53 SI-4 / IR-5',
    'EN 50600-3-1 7.3',
  ],
  'C-CTRL-03': <String>[
    'ISO/IEC 27002:2022 5.24 / 5.26',
    'NIST SP 800-53 IR-4 / IR-8',
    'ISO 22301:2019 8.4',
  ],
  'C-CTRL-04': <String>[
    'ISO/IEC 27002:2022 5.24 / 5.25 / 5.26',
    'NIST SP 800-53 IR-4',
    'BSI DER.4',
  ],
  'C-CTRL-05': <String>[
    'ISO/IEC 27002:2022 8.32',
    'NIST SP 800-53 CM-3 / CM-4',
    'BSI OPS.1.1.4.A3',
  ],
  'C-CTRL-06': <String>[
    'ISO/IEC 27002:2022 8.8',
    'NIST SP 800-53 MA-2',
    'EN 50600-3-1 7.2',
  ],
  'C-CTRL-07': <String>[
    'ISO/IEC 27002:2022 8.6',
    'EN 50600-2-3 6.3 / 6.4',
    'NIST SP 800-53 PE-14',
  ],
  'C-CTRL-08': <String>[
    'EN 50600-2-3 6.3 / 6.4',
    'ISO/IEC 27002:2022 8.6',
    'BSI INF.2.A16',
  ],
  'C-CTRL-09': <String>[
    'ISO/IEC 27002:2022 8.6',
    'ISO 22301:2019 8.3',
    'EN 50600-3-1 7.1',
  ],
  'C-CTRL-10': <String>[
    'ISO/IEC 27002:2022 5.37',
    'NIST SP 800-53 CM-8 / PL-2',
    'BSI OPS.1.1.1.A1',
  ],
  'C-CTRL-11': <String>[
    'ISO/IEC 27002:2022 8.9 / 8.32',
    'NIST SP 800-53 CM-8',
    'BSI OPS.1.1.1.A6',
  ],
  'C-CTRL-12': <String>[
    'ISO/IEC 27001:2022 9.1',
    'ISO 22301:2019 9.1',
    'NIST SP 800-53 PM-6',
  ],
  'C-CTRL-13': <String>[
    'ISO/IEC 27001:2022 9.1 / 10.1',
    'ISO 22301:2019 9.3 / 10.1',
    'NIST SP 800-53 CA-7',
  ],
  'C-CTRL-14': <String>[
    'ISO/IEC 27002:2022 5.19 / 5.20',
    'NIST SP 800-53 SR-3',
    'BSI ORP.1.A14',
  ],
  'C-CTRL-15': <String>[
    'ISO/IEC 27002:2022 5.22 / 5.23',
    'NIST SP 800-53 PS-7 / PE-16',
    'BSI INF.1.A26',
  ],
  'C-CTRL-16': <String>[
    'ISO/IEC 27002:2022 5.22',
    'ISO/IEC 27001:2022 9.3',
    'NIST SP 800-53 SR-6',
  ],
  'C-CTRL-17': <String>[
    'ISO/IEC 27002:2022 8.8',
    'NIST SP 800-53 SI-2',
    'BSI OPS.1.1.3.A16',
  ],
  'D-CTRL-01': <String>[
    'EN 50600-2-4 6.2 / 6.3',
    'ISO/IEC 27002:2022 8.21',
    'NIST SP 800-53 SC-5',
  ],
  'D-CTRL-02': <String>[
    'NIST SP 800-53 CP-8',
    'ISO/IEC 27002:2022 8.21',
    'EN 50600-2-4 6.3',
  ],
  'D-CTRL-03': <String>[
    'EN 50600-2-4 6.2 / 6.3',
    'NIST SP 800-53 PE-9(1)',
    'ISO/IEC 22237-5 6.2',
  ],
  'D-CTRL-04': <String>[
    'ISO/IEC 27002:2022 8.21',
    'NIST SP 800-53 SC-5',
    'EN 50600-2-4 6.3',
  ],
  'D-CTRL-05': <String>[
    'NIST SP 800-53 CP-8 / SC-24',
    'ISO/IEC 27002:2022 8.21',
    'EN 50600-2-4 6.3',
  ],
  'D-CTRL-06': <String>[
    'ISO/IEC 27002:2022 5.37 / 8.9',
    'NIST SP 800-53 CM-8',
    'BSI OPS.1.1.1.A1',
  ],
  'D-CTRL-07': <String>[
    'ISO/IEC 27002:2022 8.22',
    'NIST SP 800-53 SC-7',
    'BSI NET.1.1.A2',
  ],
  'D-CTRL-08': <String>[
    'ISO/IEC 27002:2022 8.20 / 8.22',
    'NIST SP 800-53 SC-7',
    'BSI NET.1.1.A3',
  ],
  'D-CTRL-09': <String>[
    'ISO/IEC 27002:2022 8.2 / 8.18 / 8.20',
    'NIST SP 800-53 AC-17 / AC-6',
    'BSI OPS.1.1.4.A8',
  ],
  'D-CTRL-10': <String>[
    'ISO/IEC 27002:2022 8.9',
    'EN 50600-2-4 6.4',
    'NIST SP 800-53 CM-8',
  ],
  'D-CTRL-11': <String>[
    'ISO/IEC 27002:2022 8.32',
    'NIST SP 800-53 CM-3',
    'BSI OPS.1.1.4.A3',
  ],
  'D-CTRL-12': <String>[
    'EN 50600-2-4 6.2 / 6.3',
    'ISO/IEC 27002:2022 8.21',
    'NIST SP 800-53 PE-9(1)',
  ],
  'D-CTRL-13': <String>[
    'ISO/IEC 27002:2022 8.20 / 8.21',
    'NIST SP 800-53 AC-17',
    'BSI OPS.1.1.4.A8',
  ],
  'D-CTRL-14': <String>[
    'ISO/IEC 27002:2022 8.2 / 8.5',
    'NIST SP 800-53 IA-2 / AC-6',
    'BSI OPS.1.1.4.A9',
  ],
  'D-CTRL-15': <String>[
    'ISO/IEC 27002:2022 5.30 / 8.2',
    'NIST SP 800-53 AC-2(4)',
    'ISO 22301:2019 8.4',
  ],
  'D-CTRL-16': <String>[
    'ISO/IEC 27002:2022 8.13 / 8.9',
    'NIST SP 800-53 CP-9',
    'BSI CON.3.A2',
  ],
  'E-CTRL-01': <String>[
    'ISO 22301:2019 5.3 / 5.4',
    'ISO/IEC 27001:2022 5.1 / 5.3',
    'BSI CON.1.A1',
  ],
  'E-CTRL-02': <String>[
    'ISO 22301:2019 7.2 / 7.3',
    'NIST SP 800-53 CP-2',
    'BSI DER.2.A1',
  ],
  'E-CTRL-03': <String>[
    'ISO 22301:2019 8.2 / 8.4',
    'ISO/IEC 27031 6 / 7',
    'NIST SP 800-53 CP-2 / CP-4',
  ],
  'E-CTRL-04': <String>[
    'ISO 22301:2019 8.3 / 8.4',
    'ISO/IEC 27031 7',
    'NIST SP 800-53 CP-2',
  ],
  'E-CTRL-05': <String>[
    'ISO/IEC 27031 7 / 8',
    'NIST SP 800-53 CP-7 / CP-8',
    'ISO 22301:2019 8.4',
  ],
  'E-CTRL-06': <String>[
    'ISO 22301:2019 8.5',
    'NIST SP 800-53 CP-4',
    'ISO/IEC 27031 8',
  ],
  'E-CTRL-07': <String>[
    'ISO 22301:2019 8.2 / 8.3',
    'ISO/IEC 27031 7.3',
    'NIST SP 800-53 CP-2',
  ],
  'E-CTRL-08': <String>[
    'ISO 22301:2019 8.3 / 8.4',
    'ISO/IEC 27031 7.4',
    'NIST SP 800-53 CP-2(2)',
  ],
  'E-CTRL-09': <String>[
    'ISO 22301:2019 8.4 / 8.5',
    'NIST SP 800-53 CP-10',
    'BSI DER.4.A3',
  ],
  'E-CTRL-10': <String>[
    'ISO 22301:2019 8.4',
    'NIST SP 800-53 CP-10',
    'ISO/IEC 27031 8.4',
  ],
  'E-CTRL-11': <String>[
    'ISO 22301:2019 7.5 / 8.5',
    'NIST SP 800-53 CP-2',
    'BSI DER.4.A4',
  ],
  'E-CTRL-12': <String>[
    'ISO 22301:2019 8.4',
    'NIST SP 800-53 IR-8 / CP-2',
    'BSI DER.2.A3',
  ],
  'E-CTRL-13': <String>[
    'ISO 22301:2019 8.4.3 / 8.4.4',
    'ISO/IEC 27035-1 8',
    'NIST SP 800-53 IR-4',
  ],
  'E-CTRL-14': <String>[
    'ISO/IEC 27002:2022 8.13',
    'NIST SP 800-53 CP-9',
    'BSI CON.3.A2',
  ],
};
