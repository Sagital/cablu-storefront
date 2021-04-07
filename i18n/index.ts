// application
import enMessages from './messages/en.json'
import { ILanguage } from '../interfaces'

const languages: ILanguage[] = [
  {
    locale: 'en',
    code: 'EN',
    name: 'English',
    icon: '/images/languages/language-1.png',
    direction: 'ltr',
    messages: enMessages,
  },
]

export default languages
