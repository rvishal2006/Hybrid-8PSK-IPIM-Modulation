<h1 align="center">📡 Hybrid 8-PSK and IPIM Modulation Scheme</h1>

<p align="center">
  <b>Transmitting two independent messages over a single time-domain waveform using 8-PSK phase modulation and 4-level delay-based IPIM.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-MATLAB-orange" alt="MATLAB">
  <img src="https://img.shields.io/badge/Modulation-8--PSK%20%2B%20IPIM-blue" alt="Modulation">
  <img src="https://img.shields.io/badge/Transport-UDP-green" alt="UDP">
  <img src="https://img.shields.io/badge/License-Custom-red" alt="License">
</p>

---

## 📌 Overview

This project presents a **Hybrid 8-PSK and 4-Level Delay-Based IPIM Modulation Scheme** for transmitting two independent messages using a common time-domain waveform.

**Message A** is encoded using **8-Phase Shift Keying (8-PSK)**, where every three input bits are mapped to one of eight carrier phases.

**Message B** is encoded using **4-level delay modulation**, where the information is represented by different delay intervals between consecutive signal segments.

The complete system is implemented in **MATLAB** and uses **UDP-based communication** to transfer the generated waveform from the transmitter to the receiver.

The receiver extracts the two information streams by analyzing:

- **Carrier phase** for Message A
- **Time-delay intervals** for Message B

---

## 🎯 Objectives

- Develop a hybrid modulation system combining 8-PSK and IPIM.
- Transmit two independent messages using a common waveform.
- Encode Message A using 8-PSK.
- Encode Message B using four different delay levels.
- Generate the hybrid time-domain signal using MATLAB.
- Transfer the signal using UDP communication.
- Detect signal segments and delay intervals at the receiver.
- Demodulate the 8-PSK signal.
- Decode the delay-based information.
- Recover both original messages at the receiver.

---

## 🧠 Proposed System

The proposed system embeds two independent information streams into one waveform by using two different signal dimensions:

| Dimension | Modulation | Information Carried |
|-----------|------------|---------------------|
| Carrier Phase | 8-PSK | Message A |
| Time Delay | 4-Level IPIM | Message B |

Both messages are first converted into binary streams. Message A determines the carrier phase of each signal segment, while Message B determines the delay interval placed between consecutive segments. The result is a single hybrid waveform that is transmitted over UDP and separated back into two messages at the receiver.

---

## 🔹 8-PSK Modulation

- **Modulation:** 8-PSK
- **Phase states:** 8 different phase states
- **Bits per symbol:** 3 bits/symbol
- **Role:** Message A is represented using the carrier phase.

Every group of three input bits is mapped to one of eight carrier phases. At the receiver, the carrier phase of each detected segment is estimated and mapped back to the corresponding three bits.

---

## 🔹 4-Level Delay-Based IPIM

- **Encoding:** 4-level delay-based encoding
- **Bits per symbol:** 2 bits/symbol
- **Role:** Message B is represented using time delay.

| Bits | Delay |
|:----:|:-----:|
| 00 | 0 ms |
| 01 | 0.5 ms |
| 10 | 1.0 ms |
| 11 | 1.5 ms |

Each pair of input bits selects one of four delay levels. The delay appears as the interval between consecutive signal segments, and the receiver measures these intervals to recover the bits.

---

## 🔄 Hybrid Modulation Principle

<pre>
                 Message A
                     │
                     ▼
             Binary Conversion
                     │
                     ▼
                  8-PSK
                     │
                     │ Phase Information
                     │
                     ▼
              ┌───────────────┐
              │               │
              │ Hybrid Signal │
              │               │
              └───────────────┘
                     ▲
                     │ Delay Information
                     │
                  IPIM
                     ▲
                     │
             Binary Conversion
                     ▲
                     │
                 Message B
</pre>

Message A controls the **phase** of each signal segment, and Message B controls the **delay** between segments. Since the two messages use different signal properties, they can be carried simultaneously in the same waveform.

---

## 📡 System Parameters

<div align="center">

<table>
  <thead>
    <tr>
      <th align="center">Parameter</th>
      <th align="center">Value</th>
    </tr>
  </thead>
  <tbody>
    <tr><td align="center">Primary Modulation</td><td align="center">8-PSK</td></tr>
    <tr><td align="center">Secondary Modulation</td><td align="center">4-Level Delay / IPIM</td></tr>
    <tr><td align="center">8-PSK Bits per Symbol</td><td align="center">3 bits</td></tr>
    <tr><td align="center">IPIM Bits per Symbol</td><td align="center">2 bits</td></tr>
    <tr><td align="center">Sampling Frequency</td><td align="center">10 kHz</td></tr>
    <tr><td align="center">Symbol Rate</td><td align="center">1000 symbols/s</td></tr>
    <tr><td align="center">Carrier Frequency</td><td align="center">2000 Hz</td></tr>
    <tr><td align="center">Delay Levels</td><td align="center">0, 0.5, 1.0, 1.5 ms</td></tr>
    <tr><td align="center">Communication</td><td align="center">UDP</td></tr>
    <tr><td align="center">IP Address</td><td align="center">127.0.0.1</td></tr>
    <tr><td align="center">Transmitter Port</td><td align="center">30000</td></tr>
    <tr><td align="center">Receiver Port</td><td align="center">30001</td></tr>
  </tbody>
</table>

</div>

---

## 🏗️ System Architecture

### Overall Architecture

<pre>
                  Hybrid Signal
                       │
             ┌─────────┴─────────┐
             │                   │
             ▼                   ▼
       Phase Variation       Time Delay
             │                   │
             ▼                   ▼
           8-PSK                IPIM
             │                   │
             ▼                   ▼
        Message A            Message B
</pre>

### Transmitter Architecture

<pre>
                         ┌─────────────────┐
                         │    Message A    │
                         └────────┬────────┘
                                  │
                                  ▼
                         Binary Conversion
                                  │
                                  ▼
                             8-PSK
                         Phase Encoding
                                  │
                                  │
                                  ▼
                         ┌─────────────────┐
                         │                 │
                         │ Hybrid Waveform │──────► UDP
                         │                 │
                         └─────────────────┘
                                  ▲
                                  │
                         Delay Encoding
                              IPIM
                                  ▲
                                  │
                         Binary Conversion
                                  ▲
                                  │
                         ┌────────┴────────┐
                         │    Message B    │
                         └─────────────────┘
</pre>

---

## 💻 MATLAB Implementation

The system is implemented in two MATLAB source files:

- [transmitter.m](matlab/transmitter/transmitter.m)
- [receiver.m](matlab/receiver/receiver.m)

### Transmitter

The transmitter:

- Accepts Message A and Message B.
- Converts both messages into binary streams.
- Adds an 8-bit length field.
- Encodes Message A using 8-PSK.
- Encodes Message B using four delay levels.
- Generates the hybrid waveform.
- Displays the transmitted signal.
- Sends the waveform using UDP.

### Receiver

The receiver:

- Creates a UDP receiver.
- Waits for incoming waveform data.
- Reads the received UDP datagram.
- Converts the received data into signal samples.
- Detects signal segments.
- Detects silent gaps.
- Performs 8-PSK demodulation.
- Detects delay levels.
- Reconstructs the binary streams.
- Converts the binary data back to ASCII.
- Displays the recovered messages.

---

## 🌐 UDP Communication

**UDP datagram communication** is used between the transmitter and the receiver. The transmitter sends the generated hybrid waveform as a UDP datagram, and the receiver listens for the incoming datagram before starting signal processing.

### Configuration

| Setting | Value |
|---------|-------|
| IP Address | 127.0.0.1 |
| Transmitter Port | 30000 |
| Receiver Port | 30001 |

---

## 🔍 Receiver Signal Processing

The receiver processes the incoming waveform in the following stages:

1. **UDP Reception:** Waits for and reads the incoming UDP datagram.
2. **Sample Conversion:** Converts the received data into signal samples.
3. **Segment Detection:** Identifies the active signal segments in the waveform.
4. **Gap Detection:** Detects the silent gaps between consecutive segments.
5. **Phase Detection and 8-PSK Demodulation:** Estimates the carrier phase of each segment and maps it to 3 bits (Message A).
6. **Delay Detection:** Measures the delay interval between segments and maps it to one of the four delay levels, giving 2 bits (Message B).

---

## 🔓 Message Reconstruction

After demodulation and delay detection, the receiver:

1. Reconstructs the binary stream of Message A from the detected phases.
2. Reconstructs the binary stream of Message B from the detected delay levels.
3. Uses the 8-bit length field to determine the message length.
4. Converts each binary stream back to ASCII characters.
5. Displays the recovered Message A and Message B.

---

## 📊 Performance Parameters

The following parameters are relevant for evaluating the hybrid modulation scheme:

- **Bit Error Rate (BER)**
- **Signal-to-Noise Ratio (SNR)**
- **Spectral efficiency**
- **Data rate**
- **Delay detection accuracy**
- **Phase detection accuracy**
- **Noise tolerance**
- **Interference tolerance**

> The current implementation demonstrates **generation, transmission, reception, demodulation, and recovery of the two messages**.

---

## 🖼️ Project Output

### Transmitter Output

<p align="center">
  <img src="images/Transmitter_output.png" alt="Transmitter Output" width="850">
</p>

### Receiver Output

<p align="center">
  <img src="images/Receiver_output.png" alt="Receiver Output" width="850">
</p>

### Decoded Output

<p align="center">
  <img src="images/Decoded_output.png" alt="Decoded Messages" width="850">
</p>

---

## 🔐 Potential Applications

- Secure communication research
- Covert communication research
- Satellite communication
- Wireless sensor networks
- Internet of Things (IoT)
- Tactical communication research
- Privacy-sensitive communication systems
- Software-defined radio research

---

## ⚠️ Limitations

- The current implementation transfers the waveform over UDP on the local loopback address (127.0.0.1) rather than over a physical radio channel.
- Quantitative performance evaluation (such as BER versus SNR) is not part of the current implementation.
- Noise and interference tolerance have not been characterized in the current version.
- UDP does not guarantee delivery, ordering, or error correction.

---

## 🚀 Future Improvements

- BER versus SNR analysis under noisy channel conditions.
- Evaluation of noise and interference tolerance.
- Error-correction coding for improved reliability.
- Extension to additional delay levels or higher-order phase modulation.
- Testing over real wireless links using software-defined radio hardware.
- Automated measurement of delay and phase detection accuracy.

---

## 🛠️ Software Requirements

- MATLAB (with support for UDP communication)
- Two MATLAB sessions running simultaneously (one for the transmitter and one for the receiver)

---

## 📁 Repository Structure

<pre>
Hybrid-8PSK-IPIM-Modulation/
│
├── matlab/
│   ├── transmitter/
│   │   └── transmitter.m
│   │
│   └── receiver/
│       └── receiver.m
│
├── images/
│   ├── Transmitter_output.png
│   ├── Receiver_output.png
│   └── Decoded_output.png
│
├── docs/
│   └── project-report.pdf
│
├── LICENSE
│
└── README.md
</pre>

---

## ▶️ How to Run

1. Open MATLAB.
2. Start the receiver:

   <pre>receiver</pre>

3. Open another MATLAB session.
4. Start the transmitter:

   <pre>transmitter</pre>

5. Enter Message A and Message B when prompted.
6. Observe the generated waveform and recovered messages.

### Example

<pre>
Enter Message A (for 8-PSK): Hello
Enter Message B (for delay encoding): Yadhu
</pre>

---

## 📚 Key Technical Concepts

- Digital Communication
- 8-PSK
- Phase Shift Keying
- Index Modulation
- IPIM
- Delay-Based Modulation
- Signal Segmentation
- Phase Detection
- Carrier Demodulation
- Time-Delay Detection
- ASCII Encoding
- Binary Data Representation
- UDP Communication
- MATLAB Signal Processing

---

## 📖 References

- J. Postel, "User Datagram Protocol," RFC 768, 1980.
- J. G. Proakis and M. Salehi, *Digital Communications*, McGraw-Hill.
- MATLAB Documentation, MathWorks.
- Project report: [docs/project-report.pdf](docs/project-report.pdf)

---

## 📌 Project Status

The current implementation demonstrates generation, transmission, reception, demodulation, and recovery of two independent messages using the hybrid 8-PSK and IPIM modulation scheme.

---

## 👥 Team & Contributors

<div align="center">

<table>
  <thead>
    <tr>
      <th align="center">Team Members</th>
    </tr>
  </thead>
  <tbody>
    <tr><td align="center">Harishwar A</td></tr>
    <tr><td align="center">Vishal R</td></tr>
    <tr><td align="center">Surya M</td></tr>
  </tbody>
</table>

</div>

---

## ⚖️ License

This project is released under a **Custom License**.

See [LICENSE](LICENSE) for the complete terms.

Public viewing and educational use are permitted, while copying, forking, modification, redistribution, and commercial reuse require prior permission from the original authors.
