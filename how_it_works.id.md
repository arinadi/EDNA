# Cara Kerja: Agent EDNA
## *Dokumentasi Teknis: Software Context Engineering*

---

### Manajemen Jendela Konteks
Performa LLM bergantung pada kualitas dan fidelitas konteks yang diberikan. Agent EDNA menangani batasan teknis spesifik:

*   **Batasan Jendela Konteks (Context Window)**
    LLM memiliki batas token yang terbatas. Akurasi menurun saat jendela konteks mendekati kapasitas maksimal, sering kali menyebabkan efek **"Lost in the Middle"** di mana model mengabaikan instruksi kritis.
*   **Akurasi dan Halusinasi**
    Dalam siklus pengembangan yang panjang, model dapat kehilangan jejak batasan arsitektur awal. Hal ini menyebabkan **halusinasi** di mana AI menghasilkan kode yang bertentangan dengan keadaan global yang telah ditetapkan.
*   **Isolasi Modular (Strategi Skill Berbasis Fitur)**
    EDNA beroperasi sebagai **AI Skill** modular, menerapkan **Modularisasi Berbasis Fitur**. Setiap modul mewakili fitur yang lengkap dan terintegrasi (Desain + Logika). 
    > **Rasional:** Pengembangan berbasis lapisan sering kali menyebabkan **"Utang Dummy"**, di mana komponen UI tetap terputus dari logika backend. 
    >
    > **Integrasi Fullstack:** Dengan memberikan desain dan logika secara bersamaan, EDNA memastikan komponen berfungsi sejak awal, mencegah **"silo effect"** di mana pengembang hanya fokus pada lapisan terisolasi.
*   **Eksekusi Berbasis Dependensi**
    Modul dieksekusi dalam urutan dependensi yang ketat. Sebuah fitur hanya dianggap **"Selesai"** jika desain, frontend, dan integrasi backend telah diverifikasi bersama.

---

### Arsitektur Integrasi Client-Skill
Agent EDNA beroperasi sebagai **AI Skill** standar, mengikuti siklus hidup penemuan, pencocokan semantik, dan eksekusi di dalam agen host (Claude Code, Gemini CLI, dll.).

#### **Penemuan & Pengindeksan**
Saat startup, agen host memindai direktori yang telah ditentukan. Agen tersebut mem-parsing **YAML frontmatter** di `SKILL.md` untuk mengindeks:
*   **Identitas Skill:** Nama internal (`edna`).
*   **Pemicu Aktivasi:** Kata kunci deskriptif yang digunakan untuk pencocokan semantik.
*   **Manifesto Tool:** Deklarasi alat sistem yang diizinkan (misal: `read_file`, `write_file`, `run_shell_command`).

#### **Siklus Hidup Eksekusi**
1.  **Pemicu Semantik:** Saat input pengguna cocok dengan deskripsi skill, agen host memuat seluruh set instruksi dari `SKILL.md` ke dalam konteks aktifnya.
2.  **Isolasi Konteks (Berbasis Skill):** Untuk mencegah pembengkakan token, EDNA menggunakan pembagian referensi modular:
    > **Pemisahan Referensi:** Dengan memindahkan instruksi spesifik fase ke folder `references/` agar agen hanya memuat metadata identitas inti saat startup.
    >
    > **Konteks On-Demand:** Detail fase lengkap dan template hanya dimuat saat relevan dengan tugas saat ini. Hal ini secara signifikan mengurangi konsumsi token dasar.
3.  **Handshake Perizinan:** Agen host memberikan akses ke alat sistem yang ditentukan, memungkinkannya untuk memanipulasi filesystem lokal dan terminal.

---

### Analisis Perbandingan: Inferensi Tanpa Kelola vs. Context Engineering
Bagian ini membandingkan pembuatan kode LLM tanpa pengelolaan (one-shot prompting) dengan kerangka kerja rekayasa konteks yang dikelola.

| Aspek Teknis | One-Shot Prompting | Kerangka Kerja Terkelola (EDNA) |
|:--- |:--- |:--- |
| **Analisis Input** | Pembuatan kode langsung dari instruksi bahasa alami yang ambigu. | Ekstraksi terstruktur dari batasan implisit sebelum implementasi. |
| **Verifikasi Logika** | Mengandalkan probabilitas model untuk mengisi celah; rentan terhadap logika yang tidak konsisten. | Menerapkan **Kriteria Validasi Biner** dalam spesifikasi untuk memastikan output deterministik. |
| **Manajemen Konteks** | Menggabungkan banyak lapisan (UI/Auth/Logika) dalam satu turn, meningkatkan degradasi konteks. | Menggunakan **Modularisasi Berbasis Fitur** untuk menjaga jendela konteks tetap fokus per tugas. |
| **Strategi Pemulihan** | Penambalan (patching) heuristik pada kesalahan, yang menyebarkan utang teknis. | Menerapkan **Batas 3 Kali Percobaan** diikuti oleh **Git Rollback** otomatis ke keadaan terverifikasi. |
| **Persistensi State** | Bersifat sementara; bergantung pada riwayat sesi langsung. | Bersifat persisten; menggunakan `progress.json` dan `decisions.md` (ADR) untuk menjaga state antar sesi. |

---

### Fase Implementasi

#### **Requirement Discovery**
EDNA menggunakan penemuan sistematis untuk mengekstrak persyaratan. File `PRD.md` yang dihasilkan berfungsi sebagai **spesifikasi teknis** utama.

#### **Phase 2: Global Architecture**
*   **Pemodelan Agnostik Penyimpanan:** Entitas data didefinisikan berdasarkan hubungan dan tipe field. Detail implementasi ditangguhkan untuk menjaga logika inti tetap terlepas (decoupled).
*   **Analisis Risiko:** Identifikasi dependensi kritis dan potensi kegagalan beruntun di seluruh graf modul.

#### **Phase 3: Module Specification**
Modul didefinisikan dengan cakupan terbatas (biasanya di bawah 20 file). Setiap spesifikasi mencakup **Kriteria Lulus/Gagal Biner** untuk validasi objektif.

#### **Phase 4: Execution Loop**
EDNA menghasilkan `agent_prompt.md` yang mengarahkan implementasi. Framework ini memaksakan tinjauan dependensi dan **gerbang validasi** otomatis (linting, pemeriksaan tipe, dan pemindaian keamanan).

---

### Alur Kerja Operasional

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant EDNA as Agent EDNA (Architect)
    participant Plan as Project Plan (Context)
    participant Coder as Coding Agent (Builder)

    User->>EDNA: Berikan Ide
    
    Note over EDNA: Phase 0: Project Context
    EDNA->>EDNA: Audit Lanskap & Pilih Mode
    
    Note over EDNA: Phase 1: Requirements & PRD
    EDNA->>User: Requirement Discovery
    User->>EDNA: Input Detail
    EDNA->>Plan: Buat PRD.md
    EDNA->>User: Minta Review PRD
    User->>EDNA: Setujui PRD
    
    Note over EDNA: Phase 2: Global Architecture
    EDNA->>Plan: Buat modules.md (Data Model & Tech)
    EDNA->>User: Minta Review Arsitektur
    User->>EDNA: Setujui Arsitektur
    
    Note over EDNA: Phase 3: Granular Specs
    EDNA->>Plan: Isi reference/ & modules/ (Spek)
    
    EDNA->>User: Minta Review Rencana Akhir
    User->>EDNA: Setujui & Mulai Build
    
    Note right of Plan: Phase 4: Loop Eksekusi
    EDNA->>Coder: Berikan Prompt + Konteks
    Coder->>Plan: Baca Spek Modul Saat Ini
    Coder->>Coder: Implementasi & Validasi
    alt Sukses
        Coder->>Plan: Update log & state (progress.json)
        Coder->>User: Minta Review Modul
    else Gagal (Maks 3 kali)
        Coder->>Coder: Rollback (Git Revert)
        Coder->>User: Laporkan State Error
    end
    
    User->>Coder: Setujui Modul
    Coder->>Plan: Lanjut ke Modul Berikutnya
```

---

### 🛠️ Direktif Strategis
*   **Presisi dalam Persyaratan.**
*   **Isolasi melalui Modularitas.**
*   **Finalitas Berbasis Validasi.**
