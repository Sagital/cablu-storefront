import React from 'react'
import {
  FormControl,
  FormControlLabel,
  FormLabel,
  Grid,
  Radio,
  RadioGroup,
} from '@material-ui/core'
import { makeStyles } from '@material-ui/core/styles'

const styles = theme => ({
  root: {
    flex: 1,
    padding: theme.spacing(2, 5, 2, 2),
    marginBottom: theme.spacing(2),
    position: 'relative',
  },
  thumb: {
    marginRight: theme.spacing(2),
    width: 200,
    [theme.breakpoints.down('xs')]: {
      width: 100,
    },
  },
  label: {
    marginRight: theme.spacing(0.6),
  },
  remove: {
    position: 'absolute',
    top: 0,
    right: 0,
  },
})
const useStyles = makeStyles(styles)

export default function PaymentDetails({ methods, selectedMethodId }) {
  const getPaymentMethod = () => {
    if (methods && methods.length) {
      return methods[0].name
    } else {
      return ''
    }
  }

  console.log(methods)

  return (
    <Grid container spacing={3}>
      <Grid item xs={12} sm={6}>
        <FormControl component="fieldset">
          <FormLabel component="legend">Payment Method</FormLabel>
          <RadioGroup aria-label="gender" name="gender1">
            <FormControlLabel
              value={selectedMethodId}
              control={<Radio checked={true} />}
              label={getPaymentMethod()}
            />
          </RadioGroup>
        </FormControl>
      </Grid>

      {/*<FormControl>*/}
      {/*  <InputLabel htmlFor="my-input">Email address</InputLabel>*/}
      {/*  <Input id="my-input" aria-describedby="my-helper-text" />*/}
      {/*  <FormHelperText id="my-helper-text">We'll never share your email.</FormHelperText>*/}
      {/*</FormControl>*/}

      {/*<TextField id="standard-basic" label="Telefon" />*/}
      {/*<TextField id="standard-basic" label="Judet" />*/}
      {/*<TextField id="standard-basic" label="Localitate" />*/}
    </Grid>
  )
}
