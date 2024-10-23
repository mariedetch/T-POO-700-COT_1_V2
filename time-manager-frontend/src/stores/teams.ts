import teamService from '@/services/teams';
import type { Team, CreateTeamRequest, UpdateTeamRequest } from "@/services/teams/types";
import { defineStore } from "pinia"
import { ref } from "vue"

export const useTeamsStore = defineStore('teams', () => {
  const teams = ref<Team[]>([]);
  const selectedTeam = ref<Team | null>(null);
  const isLoading = ref(false);
  const error = ref<string | null>(null);
  const currentPage = ref<number>(1);
  const pageSize = ref<number>(1);
  const totalCount = ref<number>(1);

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

    teamService.getTeam(teamId).then((response) => {
      selectedTeam.value = response.data.data;
    })
      .catch((errors) => {
        error.value = 'Error while retrieving team.';
      })
      .finally(() => {
        isLoading.value = false;
      });
  };

  const createTeam = async (data: CreateTeamRequest): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await teamService.createTeam(data);
      teams.value.push(response.data.data);
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

  return {
    teams, selectedTeam,
    currentPage, pageSize, totalCount,
    isLoading, error,
    getTeams, getTeam,
    createTeam, updateTeam,
    deleteTeam
  };
});