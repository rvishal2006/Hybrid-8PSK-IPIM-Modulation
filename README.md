# 📡 Hybrid 8-PSK & IPIM Modulation Scheme

<p align="center">
  <h2 align="center">Hybrid 8-PSK and IPIM Modulation Scheme</h2>
</p>

<p align="center">
  <b>Digital Communication • 8-PSK • IPIM • Covert Communication • MATLAB • UDP</b>
</p>


</p>

<p align="center">
  <i>A hybrid modulation approach for transmitting two independent messages over a common carrier waveform.</i>
</p>

---

## 📌 Overview

The **Hybrid 8-PSK & IPIM Modulation Scheme** project proposes a communication system that combines **8-Phase Shift Keying (8-PSK)** and **Index-Pulse Interval Modulation (IPIM)** to transmit two independent messages over the same carrier waveform.

The first message is encoded using 8-PSK, where information is represented through different carrier phase states.

The second message is embedded using pulse-interval/delay encoding, where information is represented through timing intervals between signal pulses.

At the receiver, separate demodulation techniques are used to recover both messages.

### Project Highlights

- **Primary Technique:** Hybrid modulation
- **Modulation 1:** 8-Phase Shift Keying (8-PSK)
- **Modulation 2:** Index-Pulse Interval Modulation (IPIM)
- **Number of Messages:** Two independent messages
- **Implementation:** MATLAB
- **Communication Interface:** UDP
- **Carrier Frequency:** 2000 Hz
- **Sampling Frequency:** 10 kHz
- **Symbol Rate:** 1000 symbols/sec
- **8-PSK:** 3 bits/symbol
- **IPIM:** 2 bits/symbol using four delay levels
- **Application:** Covert and secure communication
- **Project Type:** Communication System Simulation

---

# 🎯 Objectives

The major objectives of the project are:

- Develop a hybrid modulation scheme combining 8-PSK and IPIM.
- Transmit two independent messages using a common carrier waveform.
- Encode the first message using 8-PSK phase states.
- Embed the second message using pulse-interval timing information.
- Develop a receiver capable of separating the two information streams.
- Implement transmitter and receiver algorithms in MATLAB.
- Transfer the generated waveform through UDP communication.
- Evaluate the system under different channel conditions.
- Investigate spectral efficiency, BER, covert transmission capability and robustness.
- Explore applications in secure and privacy-sensitive communication.

---

# 🧩 Proposed System

The proposed system combines two different information dimensions:

### Message A

Message A is modulated using **8-PSK**.

8-PSK uses eight distinct phase states of the carrier.

Since:

```text
log₂(8) = 3 bits/symbol
