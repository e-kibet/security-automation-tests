-- =============================================================
--  SunCulture Sample Business Data
--  users: 50 rows  |  payments: 100 rows
--  Purpose: Migration seed & SQL-injection test fixture
-- =============================================================

-- ── 1. Schema ─────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
  id             SERIAL PRIMARY KEY,
  full_name      VARCHAR(120)  NOT NULL,
  email          VARCHAR(254)  NOT NULL UNIQUE,
  phone          VARCHAR(20)   NOT NULL,
  role           VARCHAR(20)   NOT NULL DEFAULT 'customer',   -- customer | agent | admin
  region         VARCHAR(60),
  county         VARCHAR(60),
  product        VARCHAR(100),                                -- pump model purchased
  account_status VARCHAR(20)   NOT NULL DEFAULT 'active',    -- active | suspended | defaulted
  created_at     TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payments (
  id              SERIAL PRIMARY KEY,
  user_id         INT           NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount_ksh      NUMERIC(12,2) NOT NULL,
  payment_method  VARCHAR(30)   NOT NULL,                    -- mpesa | bank | cash | card
  mpesa_code      VARCHAR(20),
  payment_date    DATE          NOT NULL,
  due_date        DATE,
  status          VARCHAR(20)   NOT NULL DEFAULT 'completed', -- completed | pending | failed | reversed
  notes           VARCHAR(255)
);

-- ── 2. Users (50 rows) ────────────────────────────────────────

INSERT INTO users (id, full_name, email, phone, role, region, county, product, account_status, created_at) VALUES
(1,  'Amina Wanjiku',        'amina.wanjiku@sunculture.io',       '+254701234001', 'customer', 'Central',      'Kiambu',       'RainMaker 1+',    'active',    '2023-01-15 08:30:00'),
(2,  'James Otieno',         'james.otieno@sunculture.io',        '+254701234002', 'customer', 'Nyanza',       'Kisumu',       'RainMaker 2',     'active',    '2023-02-20 09:00:00'),
(3,  'Fatuma Hassan',        'fatuma.hassan@sunculture.io',       '+254701234003', 'customer', 'Coast',        'Kilifi',       'AgroSolar 3000L', 'active',    '2023-03-10 10:15:00'),
(4,  'Peter Kamau',          'peter.kamau@sunculture.io',         '+254701234004', 'agent',    'Rift Valley',  'Nakuru',       'N/A',             'active',    '2022-11-05 07:45:00'),
(5,  'Grace Chebet',         'grace.chebet@sunculture.io',        '+254701234005', 'customer', 'Rift Valley',  'Uasin Gishu',  'RainMaker 1+',    'suspended', '2023-04-18 11:00:00'),
(6,  'Moses Mutua',          'moses.mutua@sunculture.io',         '+254701234006', 'customer', 'Eastern',      'Machakos',     'RainMaker 2',     'active',    '2023-05-22 08:00:00'),
(7,  'Diana Achieng',        'diana.achieng@sunculture.io',       '+254701234007', 'customer', 'Western',      'Kakamega',     'AgroSolar 1500L', 'defaulted', '2022-09-30 14:00:00'),
(8,  'Samuel Kiptoo',        'samuel.kiptoo@sunculture.io',       '+254701234008', 'customer', 'Rift Valley',  'Baringo',      'RainMaker 2',     'active',    '2023-06-01 09:30:00'),
(9,  'Lilian Njeri',         'lilian.njeri@sunculture.io',        '+254701234009', 'customer', 'Central',      'Murang''a',    'AgroSolar 3000L', 'active',    '2023-07-14 13:00:00'),
(10, 'Hassan Abdi',          'hassan.abdi@sunculture.io',         '+254701234010', 'customer', 'North Eastern','Garissa',      'RainMaker 1+',    'active',    '2023-08-05 10:00:00'),
(11, 'Rose Moraa',           'rose.moraa@sunculture.io',          '+254701234011', 'customer', 'Nyanza',       'Kisii',        'RainMaker 2',     'active',    '2023-09-12 08:45:00'),
(12, 'David Kimani',         'david.kimani@sunculture.io',        '+254701234012', 'agent',    'Central',      'Nyeri',        'N/A',             'active',    '2022-07-20 07:00:00'),
(13, 'Naomi Chepkoech',      'naomi.chepkoech@sunculture.io',     '+254701234013', 'customer', 'Rift Valley',  'Nandi',        'AgroSolar 1500L', 'active',    '2023-10-03 11:30:00'),
(14, 'Ali Mohammed',         'ali.mohammed@sunculture.io',        '+254701234014', 'customer', 'Coast',        'Mombasa',      'RainMaker 1+',    'suspended', '2023-02-28 16:00:00'),
(15, 'Catherine Waweru',     'catherine.waweru@sunculture.io',    '+254701234015', 'admin',    'Nairobi',      'Nairobi',      'N/A',             'active',    '2021-06-01 08:00:00'),
(16, 'Brian Ochieng',        'brian.ochieng@sunculture.io',       '+254701234016', 'customer', 'Nyanza',       'Siaya',        'RainMaker 1+',    'active',    '2023-11-01 09:00:00'),
(17, 'Winnie Auma',          'winnie.auma@sunculture.io',         '+254701234017', 'customer', 'Western',      'Bungoma',      'RainMaker 2',     'active',    '2023-11-15 10:00:00'),
(18, 'John Mwangi',          'john.mwangi@sunculture.io',         '+254701234018', 'customer', 'Central',      'Kirinyaga',    'AgroSolar 3000L', 'active',    '2023-12-01 08:00:00'),
(19, 'Esther Njoroge',       'esther.njoroge@sunculture.io',      '+254701234019', 'customer', 'Central',      'Nyandarua',    'RainMaker 1+',    'defaulted', '2022-10-10 11:00:00'),
(20, 'Charles Omondi',       'charles.omondi@sunculture.io',      '+254701234020', 'agent',    'Nyanza',       'Homa Bay',     'N/A',             'active',    '2022-05-15 07:30:00'),
(21, 'Mercy Wambui',         'mercy.wambui@sunculture.io',        '+254701234021', 'customer', 'Central',      'Kiambu',       'AgroSolar 1500L', 'active',    '2024-01-10 09:15:00'),
(22, 'Patrick Korir',        'patrick.korir@sunculture.io',       '+254701234022', 'customer', 'Rift Valley',  'Kericho',      'RainMaker 2',     'active',    '2024-01-20 10:00:00'),
(23, 'Josephine Adhiambo',   'josephine.adhiambo@sunculture.io',  '+254701234023', 'customer', 'Nyanza',       'Migori',       'RainMaker 1+',    'suspended', '2023-08-22 14:00:00'),
(24, 'Stephen Gitonga',      'stephen.gitonga@sunculture.io',     '+254701234024', 'customer', 'Eastern',      'Embu',         'AgroSolar 3000L', 'active',    '2024-02-01 08:30:00'),
(25, 'Agnes Rotich',         'agnes.rotich@sunculture.io',        '+254701234025', 'customer', 'Rift Valley',  'Elgeyo Marakwet','RainMaker 2',   'active',    '2024-02-14 09:00:00'),
(26, 'Felix Odhiambo',       'felix.odhiambo@sunculture.io',      '+254701234026', 'customer', 'Nyanza',       'Kisumu',       'RainMaker 1+',    'active',    '2024-02-28 10:00:00'),
(27, 'Tabitha Muthoni',      'tabitha.muthoni@sunculture.io',     '+254701234027', 'customer', 'Eastern',      'Meru',         'AgroSolar 1500L', 'defaulted', '2022-12-01 08:00:00'),
(28, 'George Otieno',        'george.otieno@sunculture.io',       '+254701234028', 'customer', 'Western',      'Vihiga',       'RainMaker 2',     'active',    '2024-03-05 09:30:00'),
(29, 'Irene Wanjiru',        'irene.wanjiru@sunculture.io',       '+254701234029', 'customer', 'Central',      'Kiambu',       'RainMaker 1+',    'active',    '2024-03-10 10:00:00'),
(30, 'Michael Kipchoge',     'michael.kipchoge@sunculture.io',    '+254701234030', 'customer', 'Rift Valley',  'Uasin Gishu',  'AgroSolar 3000L', 'active',    '2024-03-15 11:00:00'),
(31, 'Susan Anyango',        'susan.anyango@sunculture.io',       '+254701234031', 'customer', 'Nyanza',       'Siaya',        'RainMaker 2',     'suspended', '2023-07-01 08:00:00'),
(32, 'Leonard Mwenda',       'leonard.mwenda@sunculture.io',      '+254701234032', 'customer', 'Eastern',      'Tharaka Nithi','RainMaker 1+',    'active',    '2024-03-20 09:00:00'),
(33, 'Angela Koech',         'angela.koech@sunculture.io',        '+254701234033', 'customer', 'Rift Valley',  'Bomet',        'AgroSolar 1500L', 'active',    '2024-04-01 10:00:00'),
(34, 'Victor Ngugi',         'victor.ngugi@sunculture.io',        '+254701234034', 'agent',    'Central',      'Kiambu',       'N/A',             'active',    '2021-09-01 07:00:00'),
(35, 'Beatrice Akinyi',      'beatrice.akinyi@sunculture.io',     '+254701234035', 'customer', 'Nyanza',       'Kisii',        'RainMaker 2',     'active',    '2024-04-10 09:30:00'),
(36, 'Kenneth Mutiso',       'kenneth.mutiso@sunculture.io',      '+254701234036', 'customer', 'Eastern',      'Kitui',        'RainMaker 1+',    'defaulted', '2023-01-20 08:00:00'),
(37, 'Priscilla Wekesa',     'priscilla.wekesa@sunculture.io',    '+254701234037', 'customer', 'Western',      'Kakamega',     'AgroSolar 3000L', 'active',    '2024-04-15 10:00:00'),
(38, 'Isaac Barasa',         'isaac.barasa@sunculture.io',        '+254701234038', 'customer', 'Western',      'Bungoma',      'RainMaker 2',     'active',    '2024-04-20 11:00:00'),
(39, 'Joyce Wambua',         'joyce.wambua@sunculture.io',        '+254701234039', 'customer', 'Eastern',      'Machakos',     'RainMaker 1+',    'suspended', '2023-05-10 14:00:00'),
(40, 'Daniel Cheruiyot',     'daniel.cheruiyot@sunculture.io',    '+254701234040', 'customer', 'Rift Valley',  'Kericho',      'AgroSolar 1500L', 'active',    '2024-05-01 08:30:00'),
(41, 'Evalyne Otieno',       'evalyne.otieno@sunculture.io',      '+254701234041', 'customer', 'Nyanza',       'Homa Bay',     'RainMaker 2',     'active',    '2024-05-05 09:00:00'),
(42, 'Francis Kariuki',      'francis.kariuki@sunculture.io',     '+254701234042', 'customer', 'Central',      'Kirinyaga',    'RainMaker 1+',    'active',    '2024-05-10 10:00:00'),
(43, 'Gladys Sang',          'gladys.sang@sunculture.io',         '+254701234043', 'customer', 'Rift Valley',  'Nandi',        'AgroSolar 3000L', 'active',    '2024-05-15 11:00:00'),
(44, 'Henry Oduya',          'henry.oduya@sunculture.io',         '+254701234044', 'agent',    'Western',      'Kakamega',     'N/A',             'active',    '2022-03-01 07:00:00'),
(45, 'Immaculate Chelimo',   'immaculate.chelimo@sunculture.io',  '+254701234045', 'customer', 'Rift Valley',  'Trans Nzoia',  'RainMaker 2',     'active',    '2024-05-20 08:00:00'),
(46, 'Julius Kamande',       'julius.kamande@sunculture.io',      '+254701234046', 'customer', 'Central',      'Murang''a',    'RainMaker 1+',    'defaulted', '2023-03-15 09:00:00'),
(47, 'Kezia Nafula',         'kezia.nafula@sunculture.io',        '+254701234047', 'customer', 'Western',      'Busia',        'AgroSolar 1500L', 'active',    '2024-06-01 10:00:00'),
(48, 'Lazarus Ochieng',      'lazarus.ochieng@sunculture.io',     '+254701234048', 'customer', 'Nyanza',       'Migori',       'RainMaker 2',     'active',    '2024-06-05 11:00:00'),
(49, 'Margaret Wangui',      'margaret.wangui@sunculture.io',     '+254701234049', 'customer', 'Central',      'Nyeri',        'AgroSolar 3000L', 'suspended', '2023-09-20 13:00:00'),
(50, 'Nicholas Tanui',       'nicholas.tanui@sunculture.io',      '+254701234050', 'customer', 'Rift Valley',  'Baringo',      'RainMaker 1+',    'active',    '2024-06-10 08:00:00');

-- ── 3. Payments (100 rows) ────────────────────────────────────

INSERT INTO payments (user_id, amount_ksh, payment_method, mpesa_code, payment_date, due_date, status, notes) VALUES
-- u1  Amina Wanjiku — consistent on-time payer
(1,  5000.00, 'mpesa', 'QKA1001AAAA', '2024-01-05', '2024-01-10', 'completed', 'Instalment Jan'),
(1,  5000.00, 'mpesa', 'QKA1002BBBB', '2024-02-04', '2024-02-10', 'completed', 'Instalment Feb'),
(1,  5000.00, 'mpesa', 'QKA1003CCCC', '2024-03-06', '2024-03-10', 'completed', 'Instalment Mar'),
-- u2  James Otieno — late payments
(2,  7500.00, 'mpesa', 'QKB2001AAAA', '2024-01-18', '2024-01-10', 'completed', 'Late Jan'),
(2,  7500.00, 'mpesa', 'QKB2002BBBB', '2024-02-15', '2024-02-10', 'completed', 'Late Feb'),
(2,  7500.00, 'bank',  NULL,           '2024-03-10', '2024-03-10', 'completed', 'Bank Mar'),
-- u3  Fatuma Hassan — lump-sum settlement
(3,  45000.00,'mpesa', 'QKC3001AAAA', '2023-12-20', NULL,         'completed', 'Full settlement'),
-- u4  Peter Kamau — agent commission
(4,  12000.00,'bank',  NULL,           '2024-01-31', NULL,         'completed', 'Commission Jan'),
(4,  9500.00, 'bank',  NULL,           '2024-02-29', NULL,         'completed', 'Commission Feb'),
(4,  11000.00,'bank',  NULL,           '2024-03-31', NULL,         'completed', 'Commission Mar'),
-- u5  Grace Chebet — suspended, mixed statuses
(5,  5000.00, 'mpesa', 'QKE5001AAAA', '2024-01-10', '2024-01-10', 'completed', 'Jan payment'),
(5,  5000.00, 'mpesa', 'QKE5002BBBB', '2024-02-12', '2024-02-10', 'failed',    'Insufficient funds'),
(5,  5000.00, 'mpesa', 'QKE5003CCCC', '2024-03-01', '2024-03-10', 'reversed',  'Disputed'),
-- u6  Moses Mutua — pending
(6,  6000.00, 'mpesa', 'QKF6001AAAA', '2024-01-08', '2024-01-10', 'completed', 'Jan instalment'),
(6,  6000.00, 'mpesa', NULL,           '2024-02-09', '2024-02-10', 'pending',   'Awaiting confirm'),
-- u7  Diana Achieng — defaulted, last payment long ago
(7,  4000.00, 'mpesa', 'QKG7001AAAA', '2023-06-05', '2023-06-10', 'completed', 'Last payment'),
-- u8  Samuel Kiptoo — card payer
(8,  8000.00, 'card',  NULL,           '2024-01-15', '2024-01-15', 'completed', 'Card Jan'),
(8,  8000.00, 'card',  NULL,           '2024-02-15', '2024-02-15', 'completed', 'Card Feb'),
(8,  8000.00, 'mpesa', 'QKH8003CCCC', '2024-03-15', '2024-03-15', 'completed', 'Mpesa Mar'),
-- u9  Lilian Njeri — cash & mpesa
(9,  10000.00,'mpesa', 'QKI9001AAAA', '2024-01-20', '2024-01-20', 'completed', 'Jan instalment'),
(9,  10000.00,'cash',  NULL,           '2024-02-20', '2024-02-20', 'completed', 'Cash via agent'),
(9,  10000.00,'mpesa', 'QKI9003CCCC', '2024-03-20', '2024-03-20', 'completed', 'Mar instalment'),
-- u10 Hassan Abdi
(10, 4500.00, 'mpesa', 'QKJ1001AAAA', '2024-01-07', '2024-01-10', 'completed', 'Jan'),
(10, 4500.00, 'mpesa', 'QKJ1002BBBB', '2024-02-09', '2024-02-10', 'completed', 'Feb'),
(10, 4500.00, 'mpesa', 'QKJ1003CCCC', '2024-03-08', '2024-03-10', 'completed', 'Mar'),
-- u11 Rose Moraa
(11, 5500.00, 'mpesa', 'QKK1101AAAA', '2024-01-03', '2024-01-05', 'completed', 'Jan'),
(11, 5500.00, 'mpesa', 'QKK1102BBBB', '2024-02-04', '2024-02-05', 'completed', 'Feb'),
-- u12 David Kimani — senior agent
(12, 15000.00,'bank',  NULL,           '2024-01-31', NULL,         'completed', 'Commission Jan'),
(12, 14000.00,'bank',  NULL,           '2024-02-29', NULL,         'completed', 'Commission Feb'),
-- u13 Naomi Chepkoech
(13, 7000.00, 'mpesa', 'QKM1301AAAA', '2024-01-12', '2024-01-15', 'completed', 'Jan'),
(13, 7000.00, 'mpesa', 'QKM1302BBBB', '2024-02-14', '2024-02-15', 'completed', 'Feb'),
-- u14 Ali Mohammed — suspended
(14, 3500.00, 'mpesa', 'QKN1401AAAA', '2024-02-01', '2024-01-30', 'failed',    'Account suspended'),
-- u15 Catherine Waweru — admin test entry
(15, 0.00,   'bank',  NULL,           '2024-01-01', NULL,         'completed', 'System test entry'),
-- u16 Brian Ochieng
(16, 5200.00, 'mpesa', 'QKP1601AAAA', '2024-01-10', '2024-01-10', 'completed', 'Jan'),
(16, 5200.00, 'mpesa', 'QKP1602BBBB', '2024-02-10', '2024-02-10', 'completed', 'Feb'),
(16, 5200.00, 'mpesa', 'QKP1603CCCC', '2024-03-11', '2024-03-10', 'completed', 'Mar'),
-- u17 Winnie Auma
(17, 6800.00, 'mpesa', 'QKQ1701AAAA', '2024-01-14', '2024-01-15', 'completed', 'Jan'),
(17, 6800.00, 'cash',  NULL,           '2024-02-15', '2024-02-15', 'completed', 'Cash Feb'),
-- u18 John Mwangi — large account
(18, 12000.00,'mpesa', 'QKR1801AAAA', '2024-01-05', '2024-01-05', 'completed', 'Jan'),
(18, 12000.00,'mpesa', 'QKR1802BBBB', '2024-02-05', '2024-02-05', 'completed', 'Feb'),
(18, 12000.00,'bank',  NULL,           '2024-03-05', '2024-03-05', 'completed', 'Bank Mar'),
-- u19 Esther Njoroge — defaulted
(19, 4000.00, 'mpesa', 'QKS1901AAAA', '2022-11-10', '2022-11-10', 'completed', 'Last payment before default'),
-- u20 Charles Omondi — agent
(20, 8500.00, 'bank',  NULL,           '2024-01-31', NULL,         'completed', 'Commission Jan'),
(20, 9200.00, 'bank',  NULL,           '2024-02-29', NULL,         'completed', 'Commission Feb'),
-- u21 Mercy Wambui
(21, 5000.00, 'mpesa', 'QKU2101AAAA', '2024-02-01', '2024-02-01', 'completed', 'First instalment'),
(21, 5000.00, 'mpesa', 'QKU2102BBBB', '2024-03-01', '2024-03-01', 'completed', 'Second instalment'),
-- u22 Patrick Korir
(22, 7200.00, 'mpesa', 'QKV2201AAAA', '2024-02-05', '2024-02-05', 'completed', 'Jan/Feb combined'),
(22, 7200.00, 'mpesa', 'QKV2202BBBB', '2024-03-05', '2024-03-05', 'completed', 'Mar instalment'),
-- u23 Josephine Adhiambo — suspended
(23, 4500.00, 'mpesa', 'QKW2301AAAA', '2023-09-10', '2023-09-10', 'completed', 'Sep before suspension'),
(23, 4500.00, 'mpesa', 'QKW2302BBBB', '2023-10-15', '2023-10-10', 'failed',    'Failed post-suspension'),
-- u24 Stephen Gitonga
(24, 13000.00,'mpesa', 'QKX2401AAAA', '2024-02-15', '2024-02-15', 'completed', 'Feb instalment'),
(24, 13000.00,'mpesa', 'QKX2402BBBB', '2024-03-15', '2024-03-15', 'completed', 'Mar instalment'),
-- u25 Agnes Rotich
(25, 6500.00, 'mpesa', 'QKY2501AAAA', '2024-03-01', '2024-03-01', 'completed', 'Mar instalment'),
(25, 6500.00, 'mpesa', NULL,           '2024-04-01', '2024-04-01', 'pending',   'Apr pending'),
-- u26 Felix Odhiambo
(26, 5000.00, 'mpesa', 'QKZ2601AAAA', '2024-03-05', '2024-03-05', 'completed', 'First payment'),
-- u27 Tabitha Muthoni — defaulted
(27, 3800.00, 'mpesa', 'QLA2701AAAA', '2023-02-01', '2023-02-01', 'completed', 'Last payment'),
(27, 3800.00, 'mpesa', 'QLA2702BBBB', '2023-03-05', '2023-03-01', 'failed',    'Failed — defaulted'),
-- u28 George Otieno
(28, 7000.00, 'mpesa', 'QLB2801AAAA', '2024-03-10', '2024-03-10', 'completed', 'Mar instalment'),
(28, 7000.00, 'mpesa', NULL,           '2024-04-10', '2024-04-10', 'pending',   'Apr pending'),
-- u29 Irene Wanjiru
(29, 5500.00, 'mpesa', 'QLC2901AAAA', '2024-03-15', '2024-03-15', 'completed', 'Mar instalment'),
(29, 5500.00, 'mpesa', 'QLC2902BBBB', '2024-04-15', '2024-04-15', 'completed', 'Apr instalment'),
-- u30 Michael Kipchoge — large AgroSolar
(30, 15000.00,'bank',  NULL,           '2024-03-20', '2024-03-20', 'completed', 'Mar instalment bank'),
(30, 15000.00,'mpesa', 'QLD3001AAAA', '2024-04-20', '2024-04-20', 'completed', 'Apr instalment mpesa'),
-- u31 Susan Anyango — suspended
(31, 4200.00, 'mpesa', 'QLE3101AAAA', '2023-08-05', '2023-08-05', 'completed', 'Aug payment'),
(31, 4200.00, 'mpesa', 'QLE3102BBBB', '2023-09-10', '2023-09-05', 'reversed',  'Reversed — dispute'),
-- u32 Leonard Mwenda
(32, 5000.00, 'mpesa', 'QLF3201AAAA', '2024-04-01', '2024-04-01', 'completed', 'Apr instalment'),
-- u33 Angela Koech
(33, 6000.00, 'mpesa', 'QLG3301AAAA', '2024-04-05', '2024-04-05', 'completed', 'Apr instalment'),
(33, 6000.00, 'cash',  NULL,           '2024-05-05', '2024-05-05', 'completed', 'Cash May'),
-- u34 Victor Ngugi — agent
(34, 10500.00,'bank',  NULL,           '2024-03-31', NULL,         'completed', 'Commission Mar'),
(34, 11200.00,'bank',  NULL,           '2024-04-30', NULL,         'completed', 'Commission Apr'),
-- u35 Beatrice Akinyi
(35, 5800.00, 'mpesa', 'QLI3501AAAA', '2024-04-15', '2024-04-15', 'completed', 'Apr instalment'),
(35, 5800.00, 'mpesa', NULL,           '2024-05-15', '2024-05-15', 'pending',   'May pending'),
-- u36 Kenneth Mutiso — defaulted
(36, 3200.00, 'mpesa', 'QLJ3601AAAA', '2023-04-01', '2023-04-01', 'completed', 'Before default'),
-- u37 Priscilla Wekesa — AgroSolar large
(37, 14000.00,'mpesa', 'QLK3701AAAA', '2024-04-20', '2024-04-20', 'completed', 'Apr instalment'),
(37, 14000.00,'bank',  NULL,           '2024-05-20', '2024-05-20', 'completed', 'May bank'),
-- u38 Isaac Barasa
(38, 7500.00, 'mpesa', 'QLL3801AAAA', '2024-04-22', '2024-04-22', 'completed', 'Apr instalment'),
-- u39 Joyce Wambua — suspended
(39, 4000.00, 'mpesa', 'QLM3901AAAA', '2023-06-01', '2023-06-01', 'completed', 'Jun before suspension'),
(39, 4000.00, 'mpesa', 'QLM3902BBBB', '2023-07-05', '2023-07-01', 'failed',    'Failed — suspended'),
-- u40 Daniel Cheruiyot
(40, 6200.00, 'mpesa', 'QLN4001AAAA', '2024-05-05', '2024-05-05', 'completed', 'May instalment'),
(40, 6200.00, 'card',  NULL,           '2024-06-05', '2024-06-05', 'completed', 'Card Jun'),
-- u41 Evalyne Otieno
(41, 7000.00, 'mpesa', 'QLO4101AAAA', '2024-05-08', '2024-05-08', 'completed', 'May instalment'),
-- u42 Francis Kariuki
(42, 5000.00, 'mpesa', 'QLP4201AAAA', '2024-05-12', '2024-05-12', 'completed', 'May instalment'),
(42, 5000.00, 'mpesa', 'QLP4202BBBB', '2024-06-12', '2024-06-12', 'completed', 'Jun instalment'),
-- u43 Gladys Sang — large AgroSolar
(43, 16000.00,'bank',  NULL,           '2024-05-15', '2024-05-15', 'completed', 'May bank'),
(43, 16000.00,'mpesa', 'QLQ4302BBBB', '2024-06-15', '2024-06-15', 'completed', 'Jun mpesa'),
-- u44 Henry Oduya — agent
(44, 9800.00, 'bank',  NULL,           '2024-04-30', NULL,         'completed', 'Commission Apr'),
(44, 10200.00,'bank',  NULL,           '2024-05-31', NULL,         'completed', 'Commission May'),
-- u45 Immaculate Chelimo
(45, 7500.00, 'mpesa', 'QLS4501AAAA', '2024-05-22', '2024-05-22', 'completed', 'May instalment'),
(45, 7500.00, 'mpesa', NULL,           '2024-06-22', '2024-06-22', 'pending',   'Jun pending'),
-- u46 Julius Kamande — defaulted
(46, 4500.00, 'mpesa', 'QLT4601AAAA', '2023-05-01', '2023-05-01', 'completed', 'Before default'),
(46, 4500.00, 'mpesa', 'QLT4602BBBB', '2023-06-05', '2023-06-01', 'failed',    'Failed — defaulted'),
-- u47 Kezia Nafula
(47, 6000.00, 'mpesa', 'QLU4701AAAA', '2024-06-05', '2024-06-05', 'completed', 'Jun instalment'),
-- u48 Lazarus Ochieng
(48, 7200.00, 'mpesa', 'QLV4801AAAA', '2024-06-08', '2024-06-08', 'completed', 'Jun instalment'),
-- u49 Margaret Wangui — suspended, reversed
(49, 13000.00,'mpesa', 'QLW4901AAAA', '2023-10-10', '2023-10-10', 'completed', 'Oct payment'),
(49, 13000.00,'mpesa', 'QLW4902BBBB', '2023-11-15', '2023-11-10', 'reversed',  'Reversed — dispute'),
-- u50 Nicholas Tanui
(50, 5500.00, 'mpesa', 'QLX5001AAAA', '2024-06-12', '2024-06-12', 'completed', 'Jun instalment'),
(50, 5500.00, 'mpesa', NULL,           '2024-07-12', '2024-07-12', 'pending',   'Jul pending');
