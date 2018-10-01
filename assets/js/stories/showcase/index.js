import React, { Fragment } from 'react';
import { ThemeProvider, createGlobalStyle } from 'styled-components';
import { storiesOf } from '@storybook/react';
import { action } from '@storybook/addon-actions';
import Authenticate from '../../components/Authenticate';
import Container from '../../components/Container';
import Showcase from '../../components/Showcase';
import Navbar from '../../components/Navbar'
import TeamsView from '../../components/TeamsView'
import SimpleView from '../../components/SimpleView';
import Grid from '../../components/Grid'
import GridItem from '../../components/GridCell'
import theme from '../../theme';

const GlobalStyle = createGlobalStyle`
  body {
    margin: 0px;
    padding: 0px;
    background: ${props => props.theme.colors.background};
    color: ${props => props.theme.colors.text};
    fontSize: 2vw;
  }
`;

const ShowcaseDecorator = storyFn => (
  <Showcase>
    {storyFn()}
  </Showcase>
);

const ThemeDecorator = storyFn => (
  <ThemeProvider theme={theme}>
    <Fragment>
      <GlobalStyle />
      {storyFn()}
    </Fragment>
  </ThemeProvider>
)

const ContainerDecorator = storyFn => (
  <Container>
    {storyFn()}
  </Container>
)

storiesOf('Components', module)
  .addDecorator(ShowcaseDecorator)
  .addDecorator(ThemeDecorator)
  .add('with text', () => (
    <button onClick={action('clicked')}>Hello Button</button>
  ))
  .add('with some emoji', () => (
    <button onClick={action('clicked')}><span role="img" aria-label="so cool">😀 😎 👍 💯</span></button>
  ))
  .add('Authenticate', () => (
    <Authenticate />
  ))
  .add('Teams view', () => (
    <TeamsView
      teams={[
        { id: 1, name: 'org1/bandits' },
        { id: 2, name: 'org2/ogres'},
        { id: 3, name: 'org4/waiters' }
      ]}
      selectTeam={action('clicked team')}
    />
  ))
  .add('Navbar', () => (
    <Navbar />
  ))
  .add('SimpleView', () => (
    <SimpleView title="New simple view">
      <p>Down by the bay</p>
      <p>Where the watermalons grow</p>
    </SimpleView>
  ))

storiesOf('Components', module)
  .addDecorator(ThemeDecorator)
  .addDecorator(ContainerDecorator)
  .add('Grid', () => (
    <Grid>
      <GridItem
        default={{ area: '1 / 1 / 2 / -1' }}
      >
        <Navbar />
      </GridItem>
      <GridItem
        default={{ area: '2 / 1 / -1 / 4' }}
        tablet={{ area: '2 / 1 / -1 / 6' }}
        mobile={{ area: '2 / 1 / -1 / 8' }}
      >
        <SimpleView title="New simple view">
          <p>Down by the bay</p>
          <p>Where the watermalons grow</p>
          <p>Down by the bay</p>
          <p>Where the watermalons grow</p>
          <p>Down by the bay</p>
          <p>Where the watermalons grow</p>
          <p>Down by the bay</p>
          <p>Where the watermalons grow</p>
        </SimpleView>
      </GridItem>
    </Grid>
  ))
