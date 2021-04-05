import React, { useState, useEffect } from 'react'
import { Grid, TextField } from '@material-ui/core'
import { Autocomplete } from '@material-ui/lab'
import regions from './regions'

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
    console.log('IN ADDRESS INPUT EFFECT')

    if (address.region) {
      fetch('/api/localities?region=' + address.region)
        .then(response => response.json())
        .then(setLocalities)
    } else {
      setLocalities([])
    }
  }, [address.region])

  const handleRegionChange = async value => {
    setAddressErrors({ ...errors, region: null, locality: null })
    setAddress({ ...address, region: value, locality: null })
  }

  return (
    <Grid container spacing={3}>
      <Grid item xs={12} sm={6}>
        <TextField
          error={!!errors.firstName}
          InputLabelProps={{ shrink: true }}
          label="Prenume"
          value={address.firstName}
          onChange={e => handleInputChange('firstName', e.target.value)}
        />
      </Grid>
      <Grid item xs={12} sm={6}>
        <TextField
          InputLabelProps={{ shrink: true }}
          error={!!errors.lastName}
          label="Nume"
          value={address.lastName}
          onChange={e => handleInputChange('lastName', e.target.value)}
        />
      </Grid>

      <Grid item xs={12} sm={6}>
        <TextField
          label="Telefon"
          error={!!errors.phone}
          InputLabelProps={{ shrink: true }}
          value={address.phone}
          onChange={e => handleInputChange('phone', e.target.value)}
        />
      </Grid>

      <Grid item xs={12} sm={6}>
        {includeEmail ? (
          <TextField
            InputLabelProps={{ shrink: true }}
            error={!!errors.email}
            label="Email"
            value={email}
            onChange={e => handleEmailChange(e.target.value)}
          />
        ) : null}
      </Grid>

      <Grid item xs={12} sm={6}>
        <Autocomplete
          options={Object.keys(regions).concat('')}
          value={address.region}
          getOptionDisabled={o => o === ''}
          getOptionLabel={k => regions[k] || ''}
          onChange={(event, value) => handleRegionChange(value)}
          renderInput={params => (
            <TextField
              {...params}
              label="Județ"
              error={!!errors.region}
              value={address.region}
              InputLabelProps={{ shrink: true }}
            />
          )}
        />
      </Grid>
      <Grid item xs={12} sm={6}>
        <Autocomplete
          options={localities}
          value={address.locality}
          fullWidth={false}
          // getOptionLabel={}
          onChange={(event, value) => handleInputChange('locality', value)}
          renderInput={params => (
            <TextField
              {...params}
              label="Oraș"
              value={address.locality}
              error={!!errors.locality}
            />
          )}
        />
      </Grid>

      <Grid item xs={12} sm={12}>
        <TextField
          fullWidth={true}
          value={address.streetAddress}
          label="Adresă"
          error={!!errors.streetAddress}
          onChange={e => handleInputChange('streetAddress', e.target.value)}
        />
      </Grid>
    </Grid>
  )
}
