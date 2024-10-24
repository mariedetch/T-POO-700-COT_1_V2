import teamService from '@/services/teams';
import type { Team, CreateTeamRequest, UpdateTeamRequest, Member, TeamStats } from "@/services/teams/types";
import { defineStore } from "pinia"
import { ref } from "vue"

export const useTeamsStore = defineStore('teams', () => {
  const teams = ref<Team[]>([]);
  const members = ref<Member[]>([]);
  const selectedTeam = ref<Team | null>(null);
  const isLoading = ref(false);
  const error = ref<string | null>(null);
  const currentPage = ref<number>(1);
  const pageSize = ref<number>(1);
  const totalCount = ref<number>(1);
  const stats = ref<TeamStats | null>(null);

  const getTeams = async (page: number = 1, perPage: number = 10) => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = (await teamService.getTeams(page, perPage)).data.data;
      teams.value = response.items;
      currentPage.value = response.page;
      pageSize.value = response.per_page;
      totalCount.value = response.total_count;
    } catch (errors) {
      error.value = 'Error when retrieving teams.';
    } finally {
      isLoading.value = false;
    }
  };

  const getTeam = async (teamId: string) => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = (await teamService.getTeam(teamId));
      selectedTeam.value = response.data.data;
    } catch (errors) {
      error.value = 'Error when retrieving team.';
    } finally {
      isLoading.value = false;
    }
  };

  const getTeamMembers = async (teamId: string) => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = (await teamService.getTeamMembers(teamId));
      members.value = response.data.data;
    } catch (errors) {
      error.value = 'Error when retrieving team.';
    } finally {
      isLoading.value = false;
    }
  };

  const createTeam = async (data: CreateTeamRequest): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await teamService.createTeam(data);
      teams.value.push({...response.data.data, member_count: data.team.user_ids.length});
      isLoading.value = false;

      return true;
    } catch (errors) {
      error.value = 'Error when creating team.';
      isLoading.value = false;
    }

    return false;
  };

  const updateTeam = async (teamId: string, data: Partial<UpdateTeamRequest>): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await teamService.updateTeam(teamId, data);
      const updatedTeam = response.data.data;
      const index = teams.value.findIndex(team => team.id === teamId);
      if (index !== -1) {
        teams.value[index] = updatedTeam;
      }
      isLoading.value = false;

      return true;
    } catch (errors) {
      error.value = 'Error when updating team.';
      isLoading.value = false;
    }

    return false;
  };

  const deleteTeam = async (teamId: string): Promise<boolean> => {
    isLoading.value = true;
    try {
      await teamService.deleteTeam(teamId);
      teams.value = teams.value.filter(team => team.id !== teamId);
      isLoading.value = false;
      return true;
    } catch (errors) {
      error.value = 'Error when deleting team.';
      isLoading.value = false;
    }
    return false;
  }

  const getStatsByTeam = async (teamId: string) => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = (await teamService.getStatsByTeam(teamId));
      stats.value = response.data.data;
    } catch (errors) {
      error.value = 'Error when retrieving team.';
    } finally {
      isLoading.value = false;
    }
  };

  return {
    teams, selectedTeam, members,
    currentPage, pageSize, totalCount,
    isLoading, error, stats,
    getStatsByTeam,
    getTeams, getTeam,
    getTeamMembers,
    createTeam, updateTeam,
    deleteTeam
  };
});