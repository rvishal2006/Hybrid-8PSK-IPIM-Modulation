# 🔐 Hybrid 8-PSK and IPIM Modulation Scheme

<p align="center">
  <b>Hybrid 8-PSK + 4-Level Delay-Based IPIM Communication System</b>
</p>

<p align="center">
  <b>Dual-Message Transmission Using Hybrid Digital Modulation</b>
</p>

<p align="center">
  MATLAB • 8-PSK • IPIM • UDP Communication • Signal Processing
</p>

---

## 📌 Overview

This project presents a **Hybrid 8-PSK and 4-Level Delay-Based IPIM Modulation Scheme** for transmitting two independent messages using a common time-domain waveform.

The first message (**Message A**) is encoded using **8-Phase Shift Keying (8-PSK)**, where every three input bits are mapped to one of eight carrier phases.

The second message (**Message B**) is encoded using **4-level delay modulation**, where the information is represented by different delay intervals between consecutive signal segments.

The complete system is implemented in **MATLAB** and uses **UDP-based communication** to transfer the generated waveform from the transmitter to the receiver.

The receiver extracts the two information streams by analyzing:

- **Carrier phase** for Message A
- **Time-delay intervals** for Message B

---

## 🎯 Objectives

- Develop a hybrid modulation system combining **8-PSK and IPIM**.
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

The proposed system combines two different information-bearing dimensions.

```text
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
