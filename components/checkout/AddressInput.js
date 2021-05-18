import React, { useState, useEffect } from 'react'
import TypeAheadDropdown from '../shared/TypeAheadDropdown'

import regions from './regions'
import classNames from 'classnames'

export default function AddressInput({
  address,
  setAddress,
  errors,
  email,
  setEmail,
  includeEmail,
  setAddressErrors,
}) {
  const [localities, setLocalities] = useState([])

  const handleInputChange = (key, value) => {
    setAddress({ ...address, [key]: value })

    setAddressErrors({ ...errors, [key]: null })
  }

  const handleEmailChange = value => {
    setEmail(value)
    setAddressErrors({ ...errors, [email]: null })
  }

  useEffect(() => {
    if (address.region) {
      fetch('/api/localities?region=' + address.region)
        .then(response => response.json())
        .then(localities => {
          const options = localities.map(l => ({ name: l, value: l }))
          setLocalities(options)
        })
    } else {
      setLocalities([])
    }
  }, [address.region])

  const setAddressRegion = async value => {
    setAddressErrors({ ...errors, region: null, locality: null })
    setAddress({ ...address, region: value, locality: null })
  }

  const setAddressLocality = async value => {
    setAddressErrors({ ...errors, locality: null })
    setAddress({ ...address, locality: value })
  }

  return (
    <>
      <div className="form-row">
        <div className="form-group col-md-6">
          <label htmlFor="checkout-first-name">First Name</label>
          <span className="invalid-feedback">Example invalid feedback text</span>
          <input
            type="text"
            className={classNames('form-control', { 'is-invalid': errors.firstName })}
            id="checkout-first-name"
            placeholder="First Name"
            value={address.firstName}
            onChange={e => handleInputChange('firstName', e.target.value)}
          />
          <div className="invalid-feedback">{errors.firstName}</div>
        </div>
        <div className="form-group col-md-6">
          <label htmlFor="checkout-last-name">Last Name</label>
          <input
            type="text"
            className={classNames('form-control', { 'is-invalid': errors.lastName })}
            id="checkout-last-name"
            placeholder="Last Name"
            value={address.lastName}
            onChange={e => handleInputChange('lastName', e.target.value)}
          />
          <div className="invalid-feedback">{errors.lastName}</div>
        </div>
      </div>

      <div className="form-row">
        {includeEmail && (
          <div className="form-group col-md-6">
            <label htmlFor="checkout-email-address">Email Address</label>
            <input
              type="text"
              className={classNames('form-control', { 'is-invalid': errors.email })}
              id="checkout-email-address"
              placeholder="Email Address"
              value={email}
              onChange={e => setEmail(e.target.value)}
            />
            <div className="invalid-feedback">{errors.email}</div>
          </div>
        )}
        <div className="form-group col-md-6">
          <label htmlFor="checkout-shipping-phone">Phone</label>
          <input
            type="text"
            value={address.phone}
            className={classNames('form-control', { 'is-invalid': errors.phone })}
            onChange={e => handleInputChange('phone', e.target.value)}
            id="checkout-shipping-phone"
            placeholder="Phone"
          />
          <div className="invalid-feedback">{errors.phone}</div>
        </div>
      </div>

      <div className="form-group">
        <label htmlFor="checkout-street-address">Street Address</label>
        <input
          type="text"
          value={address.streetAddress}
          className={classNames('form-control', { 'is-invalid': errors.streetAddress })}
          onChange={e => handleInputChange('streetAddress', e.target.value)}
          id="checkout-street-address"
          placeholder="Street Address"
        />
        <div className="invalid-feedback">{errors.streetAddress}</div>
      </div>

      <div className="form-row">
        <div className="form-group col-md-6">
          <label htmlFor="checkout-country">Region</label>

          <TypeAheadDropdown
            placeholder="Select a region"
            items={Object.keys(regions).map(k => {
              return { value: k, name: regions[k] }
            })}
            value={address.region}
            error={errors.region}
            setValue={setAddressRegion}
          />
          <div className="invalid-feedback">{errors.region}</div>
        </div>
        <div className="form-group col-md-6">
          <label htmlFor="checkout-country">City</label>

          <TypeAheadDropdown
            placeholder="Select a city"
            value={address.locality}
            items={localities}
            error={errors.locality}
            setValue={setAddressLocality}
          />
          <div className="invalid-feedback">{errors.locality}</div>
        </div>
      </div>
    </>
  )
}
