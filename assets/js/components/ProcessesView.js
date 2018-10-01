// @flow

import React from 'react';
import styled from 'styled-components';
import Team, { type TeamType } from './Team';
import SimpleView from './SimpleView';

const Wrapper = styled.div`
  border: 1px solid #ccc;
  min-width: 200px;
`

const List = styled.ul`
  list-style: none;
  margin: 0;
  padding: 0;
`

type PropsType = {
  processes: Array<*>,
  selectProcess: (number) => void,
}

const TeamsView = ({ processes, selectProcess }: PropsType) => (
  <SimpleView title="My teams">
    <List>
      {processes.map(team => (
        <Team key={team.id} selectTeam={selectProcess} team={team} />
      ))}
    </List>
  </SimpleView>
)

export default TeamsView;
