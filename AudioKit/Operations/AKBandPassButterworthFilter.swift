//
//  AKBandPassButterworthFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/10/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** A band-pass Butterworth filter.

These filters are Butterworth second-order IIR filters. They offer an almost flat passband and very good precision and stopband attenuation.
*/
@objc class AKBandPassButterworthFilter : AKParameter {

    // MARK: - Properties

    private var butbp = UnsafeMutablePointer<sp_butbp>.alloc(1)

    private var input = AKParameter()


    /** Center frequency. (in Hertz) [Default Value: 2000] */
    var centerFrequency: AKParameter = akp(2000) {
        didSet { centerFrequency.bind(&butbp.memory.freq) }
    }

    /** Bandwidth. (in Hertz) [Default Value: 100] */
    var bandwidth: AKParameter = akp(100) {
        didSet { bandwidth.bind(&butbp.memory.bw) }
    }


    // MARK: - Initializers

    /** Instantiates the filter with default values */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        bindAll()
    }

    /**
    Instantiates the filter with all values

    -parameter input Input audio signal. 
    -parameter centerFrequency Center frequency. (in Hertz) [Default Value: 2000]
    -parameter bandwidth Bandwidth. (in Hertz) [Default Value: 100]
    */
    convenience init(
        input           sourceInput: AKParameter,
        centerFrequency freqInput:   AKParameter,
        bandwidth       bwInput:     AKParameter)
    {
        self.init(input: sourceInput)
        centerFrequency = freqInput
        bandwidth       = bwInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        centerFrequency.bind(&butbp.memory.freq)
        bandwidth      .bind(&butbp.memory.bw)
    }

    /** Internal set up function */
    internal func setup() {
        sp_butbp_create(&butbp)
        sp_butbp_init(AKManager.sharedManager.data, butbp)
    }

    /** Computation of the next value */
    override func compute() {
        sp_butbp_compute(AKManager.sharedManager.data, butbp, &(input.leftOutput), &leftOutput);
        rightOutput = leftOutput
    }

    /** Release of memory */
    override func teardown() {
        sp_butbp_destroy(&butbp)
    }
}